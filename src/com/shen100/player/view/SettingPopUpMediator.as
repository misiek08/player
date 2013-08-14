package com.shen100.player.view {
	
	import com.shen100.player.PlayerFacade;
	import com.shen100.player.model.PlayerProxy;
	import com.shen100.player.model.vo.BitrateVO;
	import com.shen100.player.model.vo.SettingVO;
	import com.shen100.player.view.events.PlayerEvent;
	import com.shen100.player.view.ui.setting.SettingPopup;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SettingPopUpMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "SettingPopUpMediator";
		
		private var playerProxy:PlayerProxy;
		
		private var bitrate:Number;
		private var autoBitrate:Boolean;
		
		public function SettingPopUpMediator(viewComponent:SettingPopup) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			trace("onRegister**********************");
			playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			settingPopup.bitrates 		= playerProxy.bitrates;	
			for each (var bitrate:BitrateVO in playerProxy.bitrates) {
				trace(bitrate.label);	
			}
			if(playerProxy.ifAutoBitrate) {
				settingPopup.autoBitrate = true;	
			}else {
				settingPopup.selectBitrate = playerProxy.selectBitrate;	
			}
			settingPopup.bitrate = playerProxy.bitrate;
			settingPopup.chsb = playerProxy.chsbVO;
			settingPopup.submit.addEventListener(MouseEvent.CLICK, 				onSubmit);	
			settingPopup.cancel.addEventListener(MouseEvent.CLICK, 				onCancel);
			settingPopup.closeButton.addEventListener(MouseEvent.CLICK, 		onCancel);
			settingPopup.tabNavigator.addEventListener(PlayerEvent.CHANGE_CHSB, onCHSBChange);                           
		}
		
		override public function onRemove():void {
			trace("onRemove**********************");
			settingPopup.tabNavigator.settingQualityBox.destroy();
		}
		
		
		private function onSubmit(event:MouseEvent):void {
			var settingVO:SettingVO = new SettingVO();
			settingVO.chsb = settingPopup.chsb;
			settingVO.bitrate = settingPopup.selectBitrate;
			sendNotification(PlayerFacade.SETTING, settingVO);
		}
		
		private function onCancel(event:MouseEvent):void {
			sendNotification(PlayerFacade.REMOVE_POPUP_SETTING);
		}
		
		private function onCHSBChange(event:PlayerEvent):void {
			sendNotification(PlayerFacade.SETTING_CHSB, event.data);	
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
		
		public function selectPlay():void {
			settingPopup.selectPlay();
		}
		
		public function selectQua():void {
			settingPopup.selectQua();
		}
		
		public function selectCHSB():void {
			settingPopup.selectCHSB();
		}
		
		public function get quaSelected():Boolean {
			return settingPopup.quaSelected;	
		}
		
		public function get playSelected():Boolean {
			return 	settingPopup.playSelected;
		}
	
		public function get chsbSelected():Boolean {
			return 	settingPopup.chsbSelected;
		}
		
		public function get settingPopup():SettingPopup {
			return viewComponent as SettingPopup;
		}
	}
}



























