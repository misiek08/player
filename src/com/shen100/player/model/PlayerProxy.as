package com.shen100.player.model {
	
	import com.adobe.serialization.json.JSON;
	import com.shen100.core.logging.Log;
	import com.shen100.core.net.HttpService;
	import com.shen100.player.conf.ApplicationConfig;
	import com.shen100.player.model.constant.PlayerState;
	import com.shen100.player.model.constant.PlayerType;
	import com.shen100.player.model.delegate.VideoSegmentDel;
	import com.shen100.player.model.events.NetStreamEvent;
	import com.shen100.player.model.vo.AdvertVO;
	import com.shen100.player.model.vo.BitrateVO;
	import com.shen100.player.model.vo.CHSBVO;
	import com.shen100.player.model.vo.VideoVO;
	import com.shen100.player.utils.UUIDUtil;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class PlayerProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "VideoProxy";
		
		public static const VIDEO_INFO_RESULT:String 			= "videoInfoResult";
		public static const VIDEO_INFO_FAULT:String 			= "videoInfoFault";
		public static const VIDEO_BITRATE_INFO_RESULT:String 	= "videoBitrateInfoResult";
		public static const VIDEO_BITRATE_INFO_FAULT:String 	= "videoBitrateInfoFault";
		public static const VIDEO_BITRATE_CHANGED:String 		= "videoBitrateChanged";
		public static const VIDEO_META_DATA:String 				= "videoMetaData";
		public static const VIDEO_BUFFER_EMPTY:String 			= "videoBufferEmpty";
		public static const VIDEO_BUFFER_FULL:String 			= "videoBufferFull";
		
		public static const VIDEO_PLAY_PLAYHEAD:String 			= "videoPlayPlayHead"; 	//正在播视频，播放头位置改变了
		public static const VIDEO_PLAY_STREAM:String 			= "videoPlayStream";  	//正在播视频，视频流改变了
		public static const VIDEO_LOAD_LOADING:String 			= "videoLoadLoading";	//正在加载视频
		public static const VIDEO_LOAD_LOADED:String 			= "videoLoadLoaded";	//最后一个分段视频load到结尾处
		
		public static const STAGE_VIDEO_OPENED:String 			= "stageVideoOpened";
		public static const STAGE_VIDEO_CLOSED:String 			= "stageVideoClosed";
		
		public static const PLAYER_STATE_CHANGED:String 		= "playerStateChanged";
		
		public const PLAYER_TYPE:String 	= PlayerType.OUT;
		
		private const PLAYER_NAME:String 	= "ShenPlayer";
		private const MAJOR:int 			= 1;
		private const MINOR:int 			= 1;
		private const REVISION:int 			= 24;
		
		private const YUNFAN_NAME:String 	= "云帆";
		
		public var vid:String;
		public var advertVO:AdvertVO;
		public var chsbVO:CHSBVO;
		public var selectBitrate:Number;	//用户选择的码率
		public var ifAutoBitrate:Boolean;	//是否开启自动码率功能
		public var ifPreload:Boolean;
		public var ifAutoPlay:Boolean;
		public var ifOpenStageVideo:Boolean;
		public var ifOpenYunfan:Boolean;
		public var YunfanStream:Class;
		public var yunfanNO:String;
		
		private var _bitrate:Number;			//当前码率
		private var _volume:Number = 0.5;
		private var uuid:String;
		private var _videoVO:VideoVO;
		private var _playerState:String = PlayerState.PENDING;	//播放器的状态
		private var _videoSegments:Vector.<VideoSegmentDel>;
		private var _loadSegment:VideoSegmentDel;	//当前正在加载的分段视频
		private var _playSegment:VideoSegmentDel;	//当前正在播放的分段视频
		
		public function PlayerProxy() {
			super(NAME);
			uuid = UUIDUtil.create();
		}
	
		public function loadVideoInfo(vid:String):void {
			free();
			this.vid = vid;
			var url:String = ApplicationConfig.videoInfoUrl;
			url = url.replace("{vid}", vid);
			var httpService:HttpService = new HttpService();
			httpService.addResponder(onVideoInfoResult, onVideoInfoFault);
			httpService.send(url);
		}
	
		private function onVideoInfoResult(data:Object):void {
			var result:Object = com.adobe.serialization.json.JSON.decode(data as String);
			if(result.status == 1) {
				result.data.vid = vid;
				_videoVO = new VideoVO();
				_videoVO.data = result.data;
				_videoSegments = new Vector.<VideoSegmentDel>();
				var start:Number = 0;	//假设分段视频时长分别为[3, 2, 2]，那么[(0,1,2,3), (3,4,5), (5,6,7)]
				for (var i:int = 0; i < _videoVO.count; i++) {
					var videoSegData:Object = {};
					videoSegData.index = i;
					videoSegData.volume = _volume;
					videoSegData.totalTime = _videoVO.times[i];
					videoSegData.uuid = uuid;
					videoSegData.url = _videoVO.gslbUrls[i];
					videoSegData.startTime = start;
					videoSegData.YunfanStream = YunfanStream;
					start += videoSegData.totalTime;
					var videoSegmentDel:VideoSegmentDel = new VideoSegmentDel(videoSegData);
					_videoSegments.push(videoSegmentDel);
					addVideoSegmentListener(videoSegmentDel);
				}
				playerState = PlayerState.READY;
				sendNotification(PlayerProxy.VIDEO_INFO_RESULT);
			}else{
				sendNotification(PlayerProxy.VIDEO_INFO_FAULT);
			}
		}
		
		private function onVideoInfoFault(info:Object):void {
			sendNotification(PlayerProxy.VIDEO_INFO_FAULT);	
		}
		
		public function loadBitrateInfo():void {
			//视频url加上ref=out就是视频码率信息接口url
			var url:String = _videoVO.gslbUrls[0] + "?ref=out";
			var httpService:HttpService = new HttpService();
			httpService.addResponder(onBitrateInfoResult, onBitrateInfoFault);
			httpService.send(url);	
		}
		
		private function onBitrateInfoResult(data:Object):void {
			var bitrateData:Object = com.adobe.serialization.json.JSON.decode(data as String);
			_videoVO.bitrateData = bitrateData;
			var theBitrate:Number;
			if(!ifAutoBitrate) {
				theBitrate = selectBitrate;
			}else {
				theBitrate = _videoVO.bitrate;	//视频默认码率	
			}
			var bitrateVO:BitrateVO;
			for each (bitrateVO in _videoVO.bitrates) {
				if(bitrateVO.value >= theBitrate) {
					break;	
				}
			}
			_bitrate = bitrateVO.value;	
			
			
			sendNotification(PlayerProxy.VIDEO_BITRATE_INFO_RESULT, bitrateVO);		
		}
		
		private function onBitrateInfoFault(info:Object):void {
			sendNotification(PlayerProxy.VIDEO_BITRATE_INFO_FAULT);	
		}
		
		public function preload():void {
			if(_videoSegments) {
				playerState = PlayerState.PRELOAD;
				loadSegment = playSegment = _videoSegments[0];
				loadSegment.load(0, _bitrate);
			}	
		}
		
		public function play():void {
			if(_videoSegments) {
				if(playerState == PlayerState.PRELOAD) {
					resume();	
				}else {
					playerState = PlayerState.PLAYING;
					loadSegment = playSegment = _videoSegments[0];
					playSegment.play(0, _bitrate);
					sendNotification(PlayerProxy.VIDEO_BUFFER_EMPTY);
				}
			}
		}
		
		public function pause():void {
			playerState = PlayerState.PAUSE;
			playSegment.pause();
		}
		
		public function resume():void {
			playerState = PlayerState.PLAYING;
			playSegment.resume();
		}
		
		public function seek(time:int):void {
			playerState = PlayerState.PLAYING;
			Log.debug(this, "seek time: " + time);
			if( playSegment.startTime + playSegment.loadOffset <= time
							&& time <= playSegment.startTime + playSegment.loadedTime ) {
				playSegment.seek(time - playSegment.startTime);	
			} else if( loadSegment.startTime + loadSegment.loadOffset <= time 
							&& time <= loadSegment.startTime + loadSegment.loadedTime ) {
				playSegment = loadSegment;
				playSegment.seek(time - playSegment.startTime);	
			} else {
				var videoSeg:VideoSegmentDel = getVideoSegment(time);
				if(videoSeg.startTime + videoSeg.loadOffset <= time 
							&& time <= videoSeg.startTime + videoSeg.loadedTime) {
					//此时videoSeg分段视频加载到末尾, 或整个分段视频加载完，否则netStream就close了
					playSegment = videoSeg;
					playSegment.seek(time - playSegment.startTime);	
					var index:int = playSegment.index + 1;
					while (index < _videoSegments.length) {
						loadSegment = _videoSegments[index];
						if(!loadSegment.isLoaded) {
							if(!loadSegment.isLoading) {
								loadSegment.load(0, _bitrate);	
							}
							break;
						}
						index++;
					}
					if(index >= _videoSegments.length) {//后面的分段视频都加载完了
						sendNotification(PlayerProxy.VIDEO_LOAD_LOADED);
					}
				}else {
					playSegment = loadSegment = videoSeg;
					playSegment.play(time - playSegment.startTime, _bitrate);
					sendNotification(PlayerProxy.VIDEO_BUFFER_EMPTY);
				}
			}
		}
		
		public function set volume(value:Number):void {
			if(_volume != value) {
				_volume = value;
				if(playSegment) {
					playSegment.volume = value;
				}
			}
		}
		
		public function get volume():Number {
			return _volume;
		}
		
		private function getVideoSegment(time:int):VideoSegmentDel {
			var videoSegment:VideoSegmentDel;
			for each (var seg:VideoSegmentDel in _videoSegments) {
				if(seg.startTime <= time && time < seg.startTime + seg.totalTime) {
					videoSegment = seg;
					break;
				}
			}
			return videoSegment;
		}
		
		private function addVideoSegmentListener(videoSegmentDel:VideoSegmentDel):void {
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_PLAY_METADATA, 		  onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_PLAY_START, 			  onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_PLAY_PLAY, 			  onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_PLAY_STOP, 			  onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_PLAY_STREAM_NOT_FOUND, onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_BUFFER_EMPTY, 		  onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_BUFFER_FULL, 		  onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_SEEK_COMPLETE, 		  onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_SEEK_INVALID_TIME, 	  onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_LOAD_LOAD, 			  onNetStream);
			videoSegmentDel.addEventListener(NetStreamEvent.NET_STREAM_LOAD_COMPLETE, 	 	  onNetStream);
		}
		
		private function removeVideoSegmentListener(videoSegmentDel:VideoSegmentDel):void {
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_PLAY_METADATA, 		  	onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_PLAY_START, 			  	onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_PLAY_PLAY, 			  	onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_PLAY_STOP, 			  	onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_PLAY_STREAM_NOT_FOUND, 	onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_BUFFER_EMPTY, 		  	onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_BUFFER_FULL, 		  		onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_SEEK_COMPLETE, 		  	onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_SEEK_INVALID_TIME, 	  	onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_LOAD_LOAD, 			  	onNetStream);
			videoSegmentDel.removeEventListener(NetStreamEvent.NET_STREAM_LOAD_COMPLETE, 	 	  	onNetStream);
		}
	
		private function onNetStream(event:NetStreamEvent):void {
			switch(event.type) {
				case NetStreamEvent.NET_STREAM_PLAY_METADATA: {
					sendNotification(PlayerProxy.VIDEO_META_DATA, event.data);
					break;
				}
				case NetStreamEvent.NET_STREAM_PLAY_START: {
					
					break;
				}
				case NetStreamEvent.NET_STREAM_PLAY_PLAY: {
					sendNotification(PlayerProxy.VIDEO_PLAY_PLAYHEAD, playHeadTime);
					break;
				}
				case NetStreamEvent.NET_STREAM_PLAY_STREAM_NOT_FOUND:{
					break;	
				}
				case NetStreamEvent.NET_STREAM_BUFFER_EMPTY:{
					sendNotification(PlayerProxy.VIDEO_BUFFER_EMPTY);
					break;	
				}
				case NetStreamEvent.NET_STREAM_BUFFER_FULL:{
					sendNotification(PlayerProxy.VIDEO_BUFFER_FULL);
					break;	
				}
				case NetStreamEvent.NET_STREAM_PLAY_STOP: {
					if(playSegment.index + 1 < _videoSegments.length) {
						playSegment = _videoSegments[playSegment.index + 1];
						playSegment.seek(0);
					}else {
						playerState = PlayerState.STOP;
					}
					break;
				}
				case NetStreamEvent.NET_STREAM_SEEK_COMPLETE: {
					
					break;
				}
				case NetStreamEvent.NET_STREAM_SEEK_INVALID_TIME: {
					
					break;
				}
				case NetStreamEvent.NET_STREAM_LOAD_LOAD: {
					sendNotification(PlayerProxy.VIDEO_LOAD_LOADING, loadSegment.startTime + loadSegment.loadedTime);
					break;
				}
				case NetStreamEvent.NET_STREAM_LOAD_COMPLETE: {
					var index:int = loadSegment.index + 1;
					while (index < _videoSegments.length) {
						loadSegment = _videoSegments[index];
						if(!loadSegment.isLoaded) {
							sendNotification(PlayerProxy.VIDEO_LOAD_LOADING, loadSegment.startTime);
							//继续load下一个视频分段
							loadSegment.load(0, _bitrate);
							break;
						}
						index++;
					}
					if(index >= _videoSegments.length) {
						//最后一个视频分段load到结尾处	
						sendNotification(PlayerProxy.VIDEO_LOAD_LOADED);	
					}
					break;
				}
			}
		}

		private function free():void {
			if(_videoSegments) {
				for each (var videoSegment:VideoSegmentDel in  _videoSegments) {
					removeVideoSegmentListener(videoSegment);
					videoSegment.destroy();	
				}
			}
			vid = "";
			_videoVO = null;
			loadSegment = playSegment = null;
			_videoSegments = null;
			playerState = PlayerState.PENDING;
		}
		
		private function get playSegment():VideoSegmentDel {
			return _playSegment;
		}
		
		private function set playSegment(value:VideoSegmentDel):void {
			if(_playSegment != value) {
				if(_playSegment) {
					_playSegment.isPlaying = false;	
				}	
				_playSegment = value;
				if(_playSegment) {
					_playSegment.isPlaying = true;
					_playSegment.volume = volume;
					sendNotification(PlayerProxy.VIDEO_PLAY_STREAM, _playSegment.netStream);
				}else {
					sendNotification(PlayerProxy.VIDEO_PLAY_STREAM, null);	
				}
			}
		}
		
		private function get loadSegment():VideoSegmentDel {
			return _loadSegment;
		}
		
		private function set loadSegment(value:VideoSegmentDel):void {
			if(_loadSegment != value) {
				if(_loadSegment) {
					_loadSegment.isLoading = false;
				}
				_loadSegment = value;
				if(_loadSegment) {
					_loadSegment.isLoading = true;
				}
			}
		}

		public function get playHeadTime():int {
			return playSegment.startTime + playSegment.playHeadTime;
		}
		
		public function get bufferPercent():int {
			var percent:int = 100 * loadSegment.bufferLength / loadSegment.bufferTime;
			if(percent > 100) {
				percent = 100	
			}
			return percent;
		}
		
		public function get totalTime():int {
			return _videoVO.totalTime;
		}
		
		public function get times():Vector.<Number> {
			return _videoVO.times;
		}
		
		public function get title():String {
			return _videoVO.title;
		}
		
		public function get bigPicPath():String {
			return _videoVO.bigPicPath;
		}

		public function get videoCount():int {
			return _videoVO.count;
		}
		
		public function get cid():String {
			return _videoVO.cid;
		}
		
		public function get bitrates():Vector.<BitrateVO> {
			return _videoVO.bitrates;
		}
		
		public function get playerState():String {
			return _playerState;
		}
		
		public function set playerState(value:String):void {
			 if(_playerState != value) {
				 _playerState = value;	 
				 Log.debug(this, value);
				 sendNotification(PlayerProxy.PLAYER_STATE_CHANGED, _playerState);
			 }
		}
		
		public function get httpDownload():Number {
			var load:Number = 0;
			if(_videoSegments) {
				for each (var videoSegments:VideoSegmentDel in _videoSegments) {
					load += videoSegments.httpDownload;	
				}
			}
			return load;
		}
		
		public function get p2pDownload():Number {
			var load:Number = 0;
			if(_videoSegments) {
				for each (var videoSegments:VideoSegmentDel in _videoSegments) {
					load += videoSegments.p2pDownload;	
				}
			}
			return load;
		}

		public function get version():String {
			return PLAYER_NAME + " " + MAJOR + "." + MINOR + "." + REVISION;
		}
		
		public function get yunfanVersion():String {
			return YUNFAN_NAME + " " + yunfanNO;
		}

		public function get bitrate():int {
			return _bitrate;
		}

		public function set bitrate(value:int):void {
			if(_bitrate != value) {
				var bitrateVO:BitrateVO;
				for each (bitrateVO in _videoVO.bitrates) {
					if(bitrateVO.value >= value) {
						break;	
					}
				}
				_bitrate = bitrateVO.value;
				
				sendNotification(PlayerProxy.VIDEO_BITRATE_CHANGED, bitrateVO);
				
				var time:Number = playHeadTime;
				for each (var videoSegments:VideoSegmentDel in _videoSegments) {
					playSegment = loadSegment = null;
				}
				var videoSeg:VideoSegmentDel = getVideoSegment(time);
				playSegment = loadSegment = videoSeg;
				playSegment.play(time - playSegment.startTime, _bitrate);
				sendNotification(PlayerProxy.VIDEO_BUFFER_EMPTY);
			}
		}

	}
}












