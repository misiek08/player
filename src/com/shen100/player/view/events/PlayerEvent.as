package com.shen100.player.view.events {
	import flash.events.Event;
	
	public class PlayerEvent extends Event {
		
		public static const PLAY:String 			= "play";
		public static const PAUSE:String 			= "pause";
		public static const SEEK:String 			= "seek";
		public static const CHANGE_VOLUME:String 	= "changeVolume";
		public static const CHANGE_CHSB:String 		= "changeCHSB";
		public static const CHANGE_BITRATE:String 	= "changeBitrate";
		
		public var data:Object;
		
		public function PlayerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);	
		}
		
		override public function clone():Event {
			var event:PlayerEvent = new PlayerEvent(type, bubbles, cancelable);
			event.data = data;
			return event;
		}
	}
}