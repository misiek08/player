package com.shen.player.model.events {
	
	import flash.events.Event;
	
	public class NetStreamEvent extends Event {
		
		public static const NET_STREAM_PLAY_METADATA:String 			= "NetStream.Play.MetaData";
		public static const NET_STREAM_PLAY_START:String 				= "NetStream.Play.Start";
		public static const NET_STREAM_PLAY_PLAY:String 				= "NetStream.Play.Play";
		public static const NET_STREAM_PLAY_STREAM_NOT_FOUND:String 	= "NetStream.Play.StreamNotFound";
		public static const NET_STREAM_PLAY_STOP:String 				= "NetStream.Play.Stop";
		public static const NET_STREAM_BUFFER_EMPTY:String 				= "NetStream.Buffer.Empty";
		public static const NET_STREAM_BUFFER_FULL:String 				= "NetStream.Buffer.Full";
		
		public static const NET_STREAM_SEEK_COMPLETE:String 			= "NetStream.Seek.Complete";
		public static const NET_STREAM_SEEK_INVALID_TIME:String 		= "NetStream.Seek.InvalidTime";
		
		public static const NET_STREAM_LOAD_LOAD:String 				= "NetStream.Load.Load";
		public static const NET_STREAM_LOAD_COMPLETE:String 			= "NetStream.Load.Complete";
		
		public var data:Object;
		
		public function NetStreamEvent(type:String, data:Object=null, bubbles:Boolean = false, cancelable:Boolean = false) {
			this.data = data;
			super(type, bubbles, cancelable);	
		}
		
		override public function clone():Event {
			return new NetStreamEvent(type, data, bubbles, cancelable);
		}
		
		override public function toString():String {
			return formatToString("NetStreamEvent", "type", "data", "bubbles", "cancelable");
		}
	}
}









