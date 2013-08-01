package com.shen.player {
	
	import com.shen.player.controller.ChangeVolumeCommand;
	import com.shen.player.controller.DwtrackingLogCommand;
	import com.shen.player.controller.LoadBitrateInfoCommand;
	import com.shen.player.controller.LoadHotVideosCommand;
	import com.shen.player.controller.LoadVideoInfoCommand;
	import com.shen.player.controller.PauseCommand;
	import com.shen.player.controller.PlayCommand;
	import com.shen.player.controller.PopUpCommand;
	import com.shen.player.controller.ResumeCommand;
	import com.shen.player.controller.SeekCommand;
	import com.shen.player.controller.SettingCommand;
	import com.shen.player.controller.StartupCommand;
	import com.shen.player.model.PlayerProxy;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PlayerFacade extends Facade implements IFacade {
		
		public static const STARTUP:String  			= "startup";
		public static const LOAD_VIDEOINFO:String  		= "loadVideoInfo";
		public static const PLAY:String  				= "play";
		public static const PAUSE:String 				= "pause";
		public static const RESUME:String 				= "resume";
		public static const SEEK:String  				= "seek";
		public static const CHANGE_VOLUME:String 		= "changeVolume";
		public static const DWTRACKING_LOG:String 		= "DwtrackingLog";
		public static const POPUP_SETTING_QUA:String 	= "popUpSettingQua";
		public static const POPUP_SETTING_PLAY:String 	= "popUpSettingPlay";
		public static const POPUP_SETTING_CHSB:String 	= "popUpSettingCHSB";
		public static const POPUP_SHARE:String 			= "popUpShare";
		public static const REMOVE_POPUP_SETTING:String = "removePopUpSetting";
		public static const REMOVE_POPUP_SHARE:String 	= "removePopUpShare";
		public static const SETTING_CHSB:String 		= "settingCHSB";
		public static const SETTING:String 				= "setting";
		
		public function PlayerFacade(key:String) {
			super(key);    
		}
		
		public static function getInstance(key:String):PlayerFacade {
			if ( instanceMap[key] == null ){
				instanceMap[key] = new PlayerFacade(key);
			}
			return instanceMap[key] as PlayerFacade;
		}
		
		override protected function initializeController() : void {
			super.initializeController();            
			registerCommand( STARTUP, 									StartupCommand );
			registerCommand( LOAD_VIDEOINFO, 							LoadVideoInfoCommand );
			registerCommand( PlayerProxy.VIDEO_INFO_RESULT, 			LoadHotVideosCommand );
			registerCommand( PlayerProxy.VIDEO_INFO_RESULT, 			LoadBitrateInfoCommand );
			registerCommand( PlayerProxy.VIDEO_BITRATE_INFO_RESULT, 	PlayCommand );
			registerCommand( PLAY, 										PlayCommand );
			registerCommand( PAUSE, 									PauseCommand );
			registerCommand( RESUME, 									ResumeCommand );
			registerCommand( SEEK, 										SeekCommand );
			registerCommand( CHANGE_VOLUME, 							ChangeVolumeCommand );
			registerCommand( DWTRACKING_LOG, 							DwtrackingLogCommand );
			registerCommand( POPUP_SETTING_QUA, 						PopUpCommand );
			registerCommand( POPUP_SETTING_PLAY, 						PopUpCommand );
			registerCommand( POPUP_SETTING_CHSB, 						PopUpCommand );
			registerCommand( POPUP_SHARE, 								PopUpCommand );
			registerCommand( REMOVE_POPUP_SETTING, 						PopUpCommand );
			registerCommand( REMOVE_POPUP_SHARE, 						PopUpCommand );
			registerCommand( SETTING_CHSB, 								SettingCommand );
			registerCommand( SETTING, 									SettingCommand );
			
		}
		
		public function startup( app:Player ):void {
			sendNotification( STARTUP, app );
		}
		
	}
}