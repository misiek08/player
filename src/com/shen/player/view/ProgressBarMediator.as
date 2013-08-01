package com.shen.player.view {
	
	import com.shen.player.PlayerFacade;
	import com.shen.player.model.PlayerProxy;
	import com.shen.player.model.SystemProxy;
	import com.shen.player.model.constant.PlayerState;
	import com.shen.player.view.ui.control.ProgressBar;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ProgressBarMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "ProgressBarMediator";
		
		private var playerProxy:PlayerProxy;
		private var systemProxy:SystemProxy;
		
		public function ProgressBarMediator(viewComponent:ProgressBar) {
			super(NAME, viewComponent);
		}
	
		override public function onRegister():void {
			playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			systemProxy = facade.retrieveProxy(SystemProxy.NAME) as SystemProxy;
			progressBar.addEventListener(ProgressBar.DRAG, 	onSeek);
			progressBar.addEventListener(ProgressBar.CLICK, onSeek);
		}
	
		private function onSeek(event:Event):void {
			sendNotification(PlayerFacade.SEEK, progressBar.playPercent);	
		}
	
		override public function listNotificationInterests():Array {
			return [
				PlayerProxy.VIDEO_INFO_RESULT,
				PlayerProxy.PLAYER_STATE_CHANGED,
				PlayerProxy.VIDEO_PLAY_PLAYHEAD,
				PlayerProxy.VIDEO_LOAD_LOADING,
				PlayerProxy.VIDEO_LOAD_LOADED
			];
		}
		
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case PlayerProxy.VIDEO_INFO_RESULT: {
					if(systemProxy.ifDebug) {
						progressBar.createDebugRuler(playerProxy.totalTime, playerProxy.times);		
					}
					break;
				}
				case PlayerProxy.VIDEO_PLAY_PLAYHEAD: {
					var time:Number = note.getBody() as Number;
					progressBar.updatePlayProgress(time / playerProxy.totalTime);
					break;
				}
				case PlayerProxy.VIDEO_LOAD_LOADING: {
					var loadedTime:Number = note.getBody() as Number;
					progressBar.updateLoadProgress(loadedTime / playerProxy.totalTime);
					break;
				}
				case PlayerProxy.VIDEO_LOAD_LOADED: {
					progressBar.updateLoadProgress(1.0);
					break;	
				}
				case PlayerProxy.PLAYER_STATE_CHANGED: {
					if(playerProxy.playerState == PlayerState.READY) {
						progressBar.updatePlayProgress(0);
						progressBar.updateLoadProgress(0);	
					}else if(playerProxy.playerState == PlayerState.STOP) {
						progressBar.updatePlayProgress(0);	
					}
					break;
				}
			}
		}

		private function get progressBar():ProgressBar{
			return viewComponent as ProgressBar;
		}
	}
}



