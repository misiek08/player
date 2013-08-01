package com.shen.player.view 
{
	import com.shen.player.PlayerFacade;
	import com.shen.player.config.ApplicationConfig;
	import com.shen.player.model.PlayerProxy;
	import com.shen.player.model.vo.BitrateVO;
	import com.shen.player.model.vo.SettingVO;
	import com.shen.player.view.events.PlayerEvent;
	import com.shen.player.view.ui.setting.SettingPopup;
	import com.shen.player.view.ui.share.SharePopup;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SharePopUpMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "SharePopUpMediator";
		
		private var playerProxy:PlayerProxy;
	
		
		public function SharePopUpMediator(viewComponent:SharePopup) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var data:Object = {};
			data.url = ApplicationConfig.playerUrl;
			data.vid = playerProxy.vid;
			sharePopup.data = data;     
			
			sharePopup.closeButton.addEventListener(MouseEvent.CLICK, 	onClose);
			sharePopup.sinaWeibo.addEventListener(MouseEvent.CLICK, 	onSNSClick);
			sharePopup.qqWeibo.addEventListener(MouseEvent.CLICK, 		onSNSClick);
			sharePopup.douban.addEventListener(MouseEvent.CLICK, 		onSNSClick);
			sharePopup.qqPengyou.addEventListener(MouseEvent.CLICK, 	onSNSClick);
			sharePopup.kaixin.addEventListener(MouseEvent.CLICK, 		onSNSClick);
			sharePopup.tianya.addEventListener(MouseEvent.CLICK, 		onSNSClick);
			sharePopup.renren.addEventListener(MouseEvent.CLICK, 		onSNSClick);
			sharePopup.qZone.addEventListener(MouseEvent.CLICK, 		onSNSClick);
		}	
		
		private function onClose(event:MouseEvent):void {
			sendNotification(PlayerFacade.REMOVE_POPUP_SHARE);
		}
		
		private function onSNSClick(event:MouseEvent):void {
			var url:String;
			switch(event.currentTarget) {
				case sharePopup.sinaWeibo:{
					url = ApplicationConfig.shareSinaWeiboUrl;
					break;
				}
				case sharePopup.qqWeibo:{
					url = ApplicationConfig.shareQQWeiboUrl;
					break;
				}
				case sharePopup.douban:{
					url = ApplicationConfig.shareDoubanUrl;
					break;
				}
				case sharePopup.qqPengyou:{
					url = ApplicationConfig.shareQQPengyouUrl;
					break;
				}
				case sharePopup.kaixin:{
					url = ApplicationConfig.shareKaixinUrl;
					break;
				}
				case sharePopup.tianya:{
					url = ApplicationConfig.shareTianyaUrl;
					break;
				}
				case sharePopup.renren:{
					url = ApplicationConfig.shareRenrenUrl;
					break;
				}
				case sharePopup.qZone:{
					url = ApplicationConfig.shareQzoneUrl;
					break;
				}
			}
			url = url.replace("{title}", 	playerProxy.title);
			url = url.replace("{url}", 		ApplicationConfig.ku6VideoUrl.replace("{vid}", playerProxy.vid));
			url = url.replace("{pic}", 		playerProxy.bigPicPath);
			url = url.replace("{swfUrl}", 	ApplicationConfig.playerUrl);
			var request:URLRequest = new URLRequest();
			request.url = url;
			navigateToURL(request, "_blank");
		}
		
		override public function onRemove():void {
			
		}
		
		override public function listNotificationInterests():Array {
			return [
				
			];
		}
		
		override public function handleNotification(note:INotification):void {
			//			switch(note.getName()) {
			//				
			//			}
		}
		
		public function get sharePopup():SharePopup {
			return viewComponent as SharePopup;
		}
	}
}



























