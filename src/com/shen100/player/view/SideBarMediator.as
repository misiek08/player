package com.shen100.player.view {
	
	import com.shen100.player.PlayerFacade;
	import com.shen100.player.conf.ApplicationConfig;
	import com.shen100.player.model.LayoutProxy;
	import com.shen100.player.utils.JavaScriptUtil;
	import com.shen100.player.view.ui.side.SideBar;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SideBarMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "SideBarMediator";
		
		private var layoutProxy:LayoutProxy;
		
		public function SideBarMediator(viewComponent:SideBar) {
			super(NAME, viewComponent);	
		}
		
		override public function onRegister():void {
			layoutProxy = facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy;
			sideBar.screenNormalOrWide.addEventListener(MouseEvent.CLICK, 	onScreenClick);
			sideBar.windowButton.addEventListener(MouseEvent.CLICK, 		onWindowClick);
			sideBar.turnOnOrOff.addEventListener(MouseEvent.CLICK,			onLightClick);
			sideBar.shareButton.addEventListener(MouseEvent.CLICK,			onShareClick);
		}
		
		private function onWindowClick(event:MouseEvent):void {
			var request:URLRequest = new URLRequest();
			request.url = ApplicationConfig.windowPlayerUrl;
			JavaScriptUtil.openWindow(ApplicationConfig.windowPlayerUrl, 600, 400);
		}
		
		private function onScreenClick(event:MouseEvent):void {
			if(sideBar.screenNormalOrWide.isOn) {
				JavaScriptUtil.setPlayerSize(layoutProxy.normalSize.width, layoutProxy.normalSize.height);
			}else {
				JavaScriptUtil.setPlayerSize(layoutProxy.wideSize.width, layoutProxy.wideSize.height);
			}
		}
		
		private function onLightClick(event:MouseEvent):void {
			if(sideBar.turnOnOrOff.isOn) {
				JavaScriptUtil.turnOn();
			}else {
				JavaScriptUtil.turnOff();
			}	
		}
		
		private function onShareClick(event:MouseEvent):void {
			sendNotification(PlayerFacade.POPUP_SHARE);		
		}
		
		public function destorySideBar():void {
			
		}
	
		public function get sideBar():SideBar {
			return viewComponent as SideBar;
		}
	}
}