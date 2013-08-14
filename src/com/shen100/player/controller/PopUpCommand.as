package com.shen100.player.controller {
	
	import com.shen100.player.PlayerFacade;
	import com.shen100.player.managers.PopUpManager;
	import com.shen100.player.view.SettingPopUpMediator;
	import com.shen100.player.view.SharePopUpMediator;
	import com.shen100.player.view.VideoBoxMediator;
	import com.shen100.player.view.ui.setting.SettingPopup;
	import com.shen100.player.view.ui.share.SharePopup;
	
	import flash.display.DisplayObjectContainer;
	import flash.media.Video;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PopUpCommand extends SimpleCommand {
		
		override public function execute( note:INotification ) : void {
			var settingPopUpMediator:SettingPopUpMediator;
			var settingPopUp:SettingPopup;
			var sharePopUpMediator:SharePopUpMediator;
			var videoBoxMediator:VideoBoxMediator;
			switch(note.getName()) {
				case PlayerFacade.POPUP_SETTING_QUA:{
					sharePopUpMediator = facade.retrieveMediator(SharePopUpMediator.NAME) as SharePopUpMediator;
					if(sharePopUpMediator) {
						facade.removeMediator(SharePopUpMediator.NAME);	
						PopUpManager.removePopUp(sharePopUpMediator.sharePopup);
					}
					settingPopUpMediator = facade.retrieveMediator(SettingPopUpMediator.NAME) as SettingPopUpMediator;
					if(settingPopUpMediator) {
						if(settingPopUpMediator.quaSelected) {
							facade.removeMediator(SettingPopUpMediator.NAME);	
							PopUpManager.removePopUp(settingPopUpMediator.settingPopup);
						}else {
							settingPopUpMediator.selectQua();
						}
					}else {
						videoBoxMediator = facade.retrieveMediator(VideoBoxMediator.NAME) as VideoBoxMediator;                    
						settingPopUp = new SettingPopup();
						settingPopUpMediator = new SettingPopUpMediator(settingPopUp);
						settingPopUpMediator.selectQua();
						facade.registerMediator(settingPopUpMediator);
						PopUpManager.addPopUp(settingPopUp, videoBoxMediator.videoBox);	
					}
					break;
				}
					
				case PlayerFacade.POPUP_SETTING_PLAY:{
					sharePopUpMediator = facade.retrieveMediator(SharePopUpMediator.NAME) as SharePopUpMediator;
					if(sharePopUpMediator) {
						facade.removeMediator(SharePopUpMediator.NAME);	
						PopUpManager.removePopUp(sharePopUpMediator.sharePopup);
					}
					settingPopUpMediator = facade.retrieveMediator(SettingPopUpMediator.NAME) as SettingPopUpMediator;
					if(settingPopUpMediator) {
						if(settingPopUpMediator.playSelected) {
							facade.removeMediator(SettingPopUpMediator.NAME);	
							PopUpManager.removePopUp(settingPopUpMediator.settingPopup);
						}else {
							settingPopUpMediator.selectPlay();
						}
					}else {
						videoBoxMediator = facade.retrieveMediator(VideoBoxMediator.NAME) as VideoBoxMediator;                    
						settingPopUp = new SettingPopup();
						settingPopUpMediator = new SettingPopUpMediator(settingPopUp);
						settingPopUpMediator.selectPlay();
						facade.registerMediator(settingPopUpMediator);
						PopUpManager.addPopUp(settingPopUp, videoBoxMediator.videoBox);	
					}
					break;
				}	
				case PlayerFacade.REMOVE_POPUP_SETTING:{
					settingPopUpMediator = facade.retrieveMediator(SettingPopUpMediator.NAME) as SettingPopUpMediator;               
					if(settingPopUpMediator) {
						facade.removeMediator(SettingPopUpMediator.NAME);	
						PopUpManager.removePopUp(settingPopUpMediator.settingPopup);
					}
					break;
				}
				case PlayerFacade.POPUP_SHARE:{ 
					settingPopUpMediator = facade.retrieveMediator(SettingPopUpMediator.NAME) as SettingPopUpMediator;
					if(settingPopUpMediator) {
						facade.removeMediator(SettingPopUpMediator.NAME);	
						PopUpManager.removePopUp(settingPopUpMediator.settingPopup);
					}
					sharePopUpMediator = facade.retrieveMediator(SharePopUpMediator.NAME) as SharePopUpMediator;
					if(sharePopUpMediator) {
						facade.removeMediator(SharePopUpMediator.NAME);	
						PopUpManager.removePopUp(sharePopUpMediator.sharePopup);
					}else {
						var sharePopup:SharePopup = new SharePopup();
						facade.registerMediator(new SharePopUpMediator(sharePopup));
						videoBoxMediator = facade.retrieveMediator(VideoBoxMediator.NAME) as VideoBoxMediator;                    
						PopUpManager.addPopUp(sharePopup, videoBoxMediator.videoBox);	
					}	
					break;
				}
				case PlayerFacade.REMOVE_POPUP_SHARE:{
					sharePopUpMediator = facade.retrieveMediator(SharePopUpMediator.NAME) as SharePopUpMediator;               
					if(sharePopUpMediator) {
						facade.removeMediator(SharePopUpMediator.NAME);	
						PopUpManager.removePopUp(sharePopUpMediator.sharePopup);
					}
					break;
				}
			}
		}
	}
}























