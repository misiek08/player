package com.shen.player.model {
	
	import com.shen.core.geom.Size;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class LayoutProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "LayoutProxy";
		
		public var ifSideBar:Boolean;
		public var ifProgressBar:Boolean;
		public var ifControlBar:Boolean;
		public var videoScaleMode:String;
		
		public var normalSize:Size = new Size(610, 500);
		public var wideSize:Size = new Size(930, 500);
		
		public function LayoutProxy() {
			super(NAME);
		}
		
	}
}

