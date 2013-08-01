package com.shen.player.controller {
	
	import com.shen.player.PlayerFacade;
	import com.shen.player.managers.PopUpManager;
	import com.shen.player.model.PlayerProxy;
	import com.shen.player.model.SharedObjectProxy;
	import com.shen.player.model.vo.CHSBVO;
	import com.shen.player.model.vo.SettingVO;
	import com.shen.player.view.SettingPopUpMediator;
	import com.shen.player.view.VideoBoxMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SettingCommand extends SimpleCommand {
		
		override public function execute( note:INotification ) : void {
			switch(note.getName()) {
				case PlayerFacade.SETTING_CHSB:{
					var chsbVO:CHSBVO = note.getBody() as CHSBVO;
					var videoBoxMediator:VideoBoxMediator = facade.retrieveMediator(VideoBoxMediator.NAME) as VideoBoxMediator;
					trace("contrast: ", chsbVO.contrast, "saturation: ", chsbVO.saturation, "brightness: ", chsbVO.brightness, "hue", chsbVO.hue);
					videoBoxMediator.videoCHSB = chsbVO;
					break;	
				}
				case PlayerFacade.SETTING:{
					var settingVO:SettingVO = note.getBody() as SettingVO;
					var playerProxy:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(settingVO.chsb != playerProxy.chsbVO) {
						playerProxy.chsbVO = settingVO.chsb;
					}
					if(settingVO.bitrate != playerProxy.selectBitrate) {
						playerProxy.selectBitrate = settingVO.bitrate;
						if(isNaN(playerProxy.selectBitrate)) {
							playerProxy.ifAutoBitrate = true;	
						}else {
							playerProxy.ifAutoBitrate = false;
							playerProxy.bitrate = settingVO.bitrate;
						}
					}
					var sharedObjProxy:SharedObjectProxy = facade.retrieveProxy(SharedObjectProxy.NAME) as SharedObjectProxy;
					sharedObjProxy.settingVO = settingVO;
					sendNotification(PlayerFacade.REMOVE_POPUP_SETTING);
				}
			}
		}
		
	}
}




