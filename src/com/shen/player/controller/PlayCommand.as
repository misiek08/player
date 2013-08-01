package com.shen.player.controller {
	
	import com.shen.player.PlayerFacade;
	import com.shen.player.model.PlayerProxy;
	import com.shen.player.model.constant.PlayerState;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PlayCommand extends SimpleCommand {
		
		override public function execute( note:INotification ) : void {
			var playerProxy:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			switch(note.getName()) {
				case PlayerProxy.VIDEO_BITRATE_INFO_RESULT:{
					if(playerProxy.ifPreload) {
						playerProxy.preload();	
					}
					if(playerProxy.ifAutoPlay) {
						playerProxy.play();
					}
					break;
				}
				case PlayerFacade.PLAY:{
					if(playerProxy.playerState == PlayerState.PAUSE || playerProxy.playerState == PlayerState.PRELOAD) {
						playerProxy.resume();	
					}else if(playerProxy.playerState == PlayerState.STOP) {
						playerProxy.seek(0);
					}else {
						playerProxy.play();	
					}
					break;
				}
			}
		}
		
	}
}