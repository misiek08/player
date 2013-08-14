package com.shen100.player.model.delegate {
	
	import com.shen100.core.logging.Log;
	import com.shen100.player.model.events.NetStreamEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class VideoSegmentDel extends EventDispatcher {
		
		private var _index:int;
		private var _url:String;
		private var _startTime:Number;		//分段视频起点在整个视频中对应的时间
		private var _totalTime:Number;		//分段视频时长, 从后台取得的，有误差
		private var _duration:Number;		//分段视频真实时长，从metaData取得
		private var _playHeadTime:Number; 	//播放头的位置
		private var _loadOffset:Number;		//分段视频开始加载的位置离分段视频起点的偏移
		private var _rate:int;
		private var _volume:Number;
		private var _isLoading:Boolean;		//是否是正在加载的分段视频
		private var _isPlaying:Boolean;		//是否是正在播放的分段视频
		private var _timeoutId:uint;		//视频加载超时id
		private var _timeout:Number = 5000;	//超时时间
		private var isMp4:Boolean;
		
		private var YunfanStream:Class;
		private var _conn:NetConnection;
		private var _netStream:NetStream;
		private var _bufferTime:Number = 2;
		private var _metaData:Object;
		private var _isDestroy:Boolean;
		
		public function VideoSegmentDel(data:Object) {
			_index 			= data.index;
			if(data.url.indexOf("?") >= 0) {
				_url 			= data.url + "&uuid=" + data.uuid + "&start={start}&rate={rate}";	
			}else {
				_url 			= data.url + "?uuid=" + data.uuid + "&start={start}&rate={rate}";	
			}
			_startTime 		= data.startTime;
			_totalTime 		= data.totalTime;
			YunfanStream 	= data.YunfanStream;
			_conn = new NetConnection();
			_conn.connect(null);
			if(YunfanStream) {
				_netStream = new YunfanStream(_conn);
				(_netStream as Object).openLog();
			}else {
				_netStream = new NetStream(_conn);
			}
			_netStream.bufferTime = _bufferTime;
			_netStream.client = this;
			volume = data.volume;
		}
		
		public function load(time:int, rate:int):void {
			var msg:String = "[" + _index + "] load";
			Log.debug(this, msg);
			play(time, rate);
			Log.debug(this, "[" + _index + "] pause");
			_netStream.pause();
		}
		
		public function play(time:int, rate:int):void {
			if(_timeoutId) {
				clearTimeout(_timeoutId);
			}
			_timeoutId = setTimeout(reconnect, _timeout, time, rate);
			if(isPlaying) {
				stopListenPlayProgress();
			}
			if(isLoading) {
				stopListenLoadProgress();	
			}
			_loadOffset = time;
			_rate = rate;
			var theUrl:String = _url.replace("{start}", time);
			theUrl = theUrl.replace("{rate}", rate);
			var msg:String = "[" + _index + "] play " + theUrl;
			msg += "\ntime: " + time + " startTime: " + startTime + " loadOffset: " + loadOffset + " loadedTime: " + loadedTime;
			Log.debug(this, msg);
			
			
			if(theUrl.indexOf(".mp4") != -1) {
				isMp4 = true;	
			}else {
				isMp4 = false;
			}
			if(YunfanStream) {
				//url, hasQvodTerminal, vSize, vTotalTime
				_netStream.play(theUrl, false, 0, 0);
			}else {
				_netStream.play(theUrl);	
			}
		}
		
		private function reconnect(time:int, rate:int):void {
			var msg:String = "[" + _index + "] reconnect";
			Log.debug(this, msg);
			if(isPlaying) {
				play(time, rate);	
			}else {
				load(time, rate);
			}
		}
		
		public function seek(time:int):void {
			var msg:String = "[" + _index + "] seek";
			Log.debug(this, msg);
			_netStream.seek(time);	
			Log.debug(this, "[" + _index + "] resume");
			_netStream.resume();
		}
		
		public function pause():void {
			var msg:String = "[" + _index + "] pause";
			Log.debug(this, msg);
			_netStream.pause();
		}
		
		public function resume():void {
			var msg:String = "[" + _index + "] resume";
			Log.debug(this, msg);
			_netStream.resume();
		}
		
		public function set volume(value:Number):void {
			if(!_isDestroy) {
				_volume = value;
				var transform:SoundTransform = new SoundTransform();
				transform.volume = value;
				_netStream.soundTransform = transform;		
			}
		}
		
		public function onMetaData(infoObject:Object):void {
			var msg:String = "[" + _index + "] onMetaData";
			Log.debug(this, msg);
			if(isPlaying) {
				listenPlayProgress();
			}
			if(isLoading) {
				listenLoadProgress();	
			}
			if(!_metaData) {
				_metaData = infoObject;
				_duration = infoObject.duration;
				if(_loadOffset > _duration) {
					_loadOffset = _duration; //为了容错, _totalTime大于duration时
				}
				var event:NetStreamEvent = new NetStreamEvent(NetStreamEvent.NET_STREAM_PLAY_METADATA, infoObject);
				dispatchEvent(event);	
			}
		}
		
		public function onCuePoint(infoObject:Object):void {
			
		}
		
		public function onXMPData(infoObject:Object):void {
			
		}
	
		private function onNetStatus(event:NetStatusEvent):void {
			var msg:String = "[" + _index + "]"+ event.info.code;
			if(_isLoading) {
				msg += " -isLoading ";	
			}
			if(_isPlaying) {
				msg += " -isPlaying ";	
			}
			msg += "time: " + _netStream.time;
			Log.debug(this, msg);
		
			if(_timeoutId) {
				clearTimeout(_timeoutId);
			}
			var e:NetStreamEvent;
			switch(event.info.code) {
				case "NetStream.Play.Start":{
					e = new NetStreamEvent(NetStreamEvent.NET_STREAM_PLAY_START);
					break;
				}
				case "NetStream.Play.StreamNotFound":{
					e = new NetStreamEvent(NetStreamEvent.NET_STREAM_PLAY_STREAM_NOT_FOUND);
					if(isPlaying) {
						play(this._loadOffset, _rate);	
					}else {
						load(this._loadOffset, _rate);	
					}
					break;	
				}
				case "NetStream.Buffer.Empty":{
					e = new NetStreamEvent(NetStreamEvent.NET_STREAM_BUFFER_EMPTY);
					break;
				}
					
				case "NetStream.Buffer.Full":{
					e = new NetStreamEvent(NetStreamEvent.NET_STREAM_BUFFER_FULL);
					break;
				}	
				case "NetStream.Play.Stop":{
					//有个bug，有时候视频没播放完，却"NetStream.Play.Stop"
					e = new NetStreamEvent(NetStreamEvent.NET_STREAM_PLAY_STOP);	
					break;
				}
				case "NetStream.Seek.Complete":{
					e = new NetStreamEvent(NetStreamEvent.NET_STREAM_SEEK_COMPLETE);
					break;
				}
				case "NetStream.Seek.InvalidTime":{
					e = new NetStreamEvent(NetStreamEvent.NET_STREAM_SEEK_INVALID_TIME);
					break;
				}
				default:{
					e = new NetStreamEvent(event.info.code);	
					break;
				}
			}
			if(_isLoading || _isPlaying) {
				dispatchEvent(e);	
			}
		}

		public function get netStream():NetStream {
			return _netStream;
		}
		
		public function get bytesLoaded():uint {
			return _netStream.bytesLoaded;
		}
		
		public function get playHeadTime():int {
			return _playHeadTime > _totalTime ? _totalTime : _playHeadTime;//为了容错, duration大于_totalTime时
		}
	
		//分段视频已加载的时间点
		public function get loadedTime():Number {
			var percent:Number = 0;
			if(_netStream.bytesLoaded) {
				percent = _netStream.bytesLoaded / _netStream.bytesTotal;
				var time:Number = _loadOffset + percent * (_duration - _loadOffset);
				return time > _totalTime ? _totalTime : time; //为了容错, duration大于_totalTime时
			}else {
				return -1;
			}
		}
		
		//分段视频加载到末尾
		public function get isLoadToEnd():Boolean {
			return _netStream.bytesLoaded && _netStream.bytesLoaded >= _netStream.bytesTotal;
		}
		
		//整个分段视频加载完
		public function get isLoaded():Boolean {
			var result:Boolean = _loadOffset == 0 && isLoadToEnd;
			if(result) {
				var msg:String = "[" + _index + "] load comlete";
				Log.debug(this, msg);
			}
			return result;
		}
		
		public function get totalTime():int {
			return _totalTime;
		}
		
		public function get duration():Number {
			return _duration;
		}
		
		public function get startTime():Number {
			return _startTime;
		}
		
		public function get loadOffset():Number {
			return _loadOffset;
		}
	
		public function get index():int {
			return _index;
		}
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void {
			if(_isPlaying != value && !isDestroy) {
				_isPlaying = value;
				if(_isPlaying) {
					_netStream.addEventListener(NetStatusEvent.NET_STATUS, 	onNetStatus);
					_conn.addEventListener(NetStatusEvent.NET_STATUS, 		onNetStatus);
					listenPlayProgress();		
				}else {
					_netStream.pause();	
					stopListenPlayProgress();
					if(!_isLoading) { //既不是正在播放的分段视频，也不是正在加载的分段视频
						_netStream.removeEventListener(NetStatusEvent.NET_STATUS, 	onNetStatus);
						_conn.removeEventListener(NetStatusEvent.NET_STATUS, 		onNetStatus);	
					}	
				}	
			}
		}
		
		private var playTimer:Timer = new Timer(500);
		
		private function listenPlayProgress():void {
			playTimer.addEventListener(TimerEvent.TIMER, onPlayProgressTimer);
			playTimer.start();
		}
	
		private function stopListenPlayProgress():void {
			playTimer.removeEventListener(TimerEvent.TIMER, onPlayProgressTimer);
			playTimer.stop();
		}
		
		private function onPlayProgressTimer(event:TimerEvent):void {
			if(_playHeadTime != netStream.time) {
				if(isMp4) {
					_playHeadTime = _loadOffset + netStream.time;
				}else {
					_playHeadTime = netStream.time;
				}
				var e:NetStreamEvent = new NetStreamEvent(NetStreamEvent.NET_STREAM_PLAY_PLAY);
				dispatchEvent(e);
			}
		}
		
		public function get isLoading():Boolean {
			return _isLoading;
		}
		
		public function set isLoading(value:Boolean):void {
			if(_isLoading != value && !isDestroy) {
				_isLoading = value;
				if(_isLoading) {
					_netStream.addEventListener(NetStatusEvent.NET_STATUS, 	onNetStatus);
					_conn.addEventListener(NetStatusEvent.NET_STATUS, 		onNetStatus);
					listenLoadProgress();	
				}else {
					stopListenLoadProgress();
					if(!isLoadToEnd) {
						_netStream.close();
					}
					if(!_isPlaying) { //既不是正在播放的分段视频，也不是正在加载的分段视频
						_netStream.removeEventListener(NetStatusEvent.NET_STATUS, 	onNetStatus);
						_conn.removeEventListener(NetStatusEvent.NET_STATUS, 		onNetStatus);
					}	
				}	
			}
		}
		
		private var loadTimer:Timer = new Timer(500);
		
		private function listenLoadProgress():void {
			loadTimer.addEventListener(TimerEvent.TIMER, onLoadProgressTimer);
			loadTimer.start();
		}
		
		private function stopListenLoadProgress():void {
			loadTimer.removeEventListener(TimerEvent.TIMER, onLoadProgressTimer);
			loadTimer.stop();
		}
		
		private function onLoadProgressTimer(event:TimerEvent):void {
			var e:NetStreamEvent;
			if(_metaData && _netStream.bytesLoaded >= _netStream.bytesTotal) {				
				e = new NetStreamEvent(NetStreamEvent.NET_STREAM_LOAD_COMPLETE);	
			}else {
				e = new NetStreamEvent(NetStreamEvent.NET_STREAM_LOAD_LOAD);		
			}
			dispatchEvent(e);
		}
	
		public function destroy():void {
			_isDestroy = true;
			_netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_conn.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_conn.close();
			_netStream.close();
			_conn = null;
			_netStream = null;
			loadTimer.removeEventListener(TimerEvent.TIMER, onLoadProgressTimer);
			loadTimer.stop();
			loadTimer = null;
			playTimer.removeEventListener(TimerEvent.TIMER, onPlayProgressTimer);
			playTimer.stop();
			playTimer = null;
		}
		
		public function get isDestroy():Boolean {
			return _isDestroy;
		}
	
		public function get httpDownload():Number {
			var load:Number = 0;
			var data:Object = (netStream as Object).getDownloadStat();
			if(data && data.http_download) {
				load = data.http_download;
			}
			return load;
		}
		
		public function get p2pDownload():Number {
			var load:Number = 0;
			var data:Object = (netStream as Object).getDownloadStat();
			if(data && data.p2p_download) {
				load = data.p2p_download;
			}
			return load;
		}
		
		public function get bufferTime():Number {
			return netStream.bufferTime;
		}
		
		public function get bufferLength():Number {
			return netStream.bufferLength;
		} 
	}
}























