package com.shen100.player.model {
	
	import com.adobe.serialization.json.JSON;
	import com.shen100.core.net.HttpService;
	import com.shen100.player.model.vo.VideoVO;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class HotVideosProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "HotVideosProxy";
		
		public static const HOT_VIDEOS_RESULT:String	= "hotVideosResult";
		public static const HOT_VIDEOS_FAULT:String		= "hotVideosFault";
		
		public var count:int = 6;
		
		public function HotVideosProxy() {
			super(NAME, new Vector.<VideoVO>());
		}
		
		public function loadHotVideos(url:String):void {
			var httpService:HttpService = new HttpService();
			httpService.addResponder(onHotVideosResult, onHotVideosFault);
			httpService.send(url);	
		}
		
		private function onHotVideosResult(data:Object):void {
			hotVideos.splice(0, hotVideos.length);
			var result:Object = com.adobe.serialization.json.JSON.decode(data as String);
			if(result.status == 1) {
				var videoArr:Array = result.data;	
				for each (var video:Object in videoArr) {
					var videoVO:VideoVO = new VideoVO();
					videoVO.hotData = video;
					hotVideos.push(videoVO);	
				}
				sendNotification(HotVideosProxy.HOT_VIDEOS_RESULT);
			}else {
				//请求推荐视频出错
			}
		}
		
		private function onHotVideosFault(info:Object):void {
			sendNotification(HotVideosProxy.HOT_VIDEOS_FAULT);		
		}
		
		public function get hotVideos():Vector.<VideoVO> {
			return data as Vector.<VideoVO>;	
		}
		
		public function set hotVideos(value:Vector.<VideoVO>):void {
			data = value; 	
		}
		
		
		
	}
}




















