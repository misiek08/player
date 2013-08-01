package com.shen.player.model {
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class SystemProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "SystemProxy";
		
		public static const STAGE_VIDEO:String 					 	= "flash.media.StageVideo";
		public static const STAGE_VIDEO_EVENT:String 			 	= "flash.events.StageVideoEvent";
		public static const STAGE_VIDEO_AVAILABILITY:String 		= "flash.media.StageVideoAvailability";
		public static const STAGE_VIDEO_AVAILABILITY_EVENT:String 	= "flash.events.StageVideoAvailabilityEvent";
		
		public static const YunfanStream:String 					= "YunfanStream";
		
		public var ifDebug:Boolean;
		public var stageVideoSupported:Boolean;
		public var version:String;
		
		public function SystemProxy() {
			super(NAME);	
		}
		
	}
}