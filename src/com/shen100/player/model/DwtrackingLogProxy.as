package com.shen100.player.model {
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class DwtrackingLogProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "DwtrackingLogProxy";
		
		public static const VIEW:String = "view";
		
		public static const DWTRACKING_LOG:String 		= "DwtrackingLog";
	
		private var timer:Timer = new Timer(5000);
		
		public function DwtrackingLogProxy() {
			super(NAME);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			//timer.start();
		}
	
		private function onTimer(event:TimerEvent):void {
			sendNotification(DwtrackingLogProxy.DWTRACKING_LOG, VIEW);	
		}
		
	}
}