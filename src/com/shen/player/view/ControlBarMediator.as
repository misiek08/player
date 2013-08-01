package com.shen.player.view {
	
	import com.shen.player.PlayerFacade;
	import com.shen.player.model.PlayerProxy;
	import com.shen.player.model.constant.PlayerState;
	import com.shen.player.model.vo.BitrateVO;
	import com.shen.player.utils.PlayerUtil;
	import com.shen.player.view.ui.control.ControlBar;
	import com.shen.player.view.ui.control.VolumeBox;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ControlBarMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "ControlBarMediator";
		
		private var playerProxy:PlayerProxy;
		private var _totalTimeStr:String;
		
		public function ControlBarMediator(viewComponent:ControlBar) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(playerProxy.playerState == PlayerState.PLAYING || playerProxy.playerState == PlayerState.PAUSE) {
				controlBar.bitrateButton.mouseEnabled = true;
				controlBar.bitrateButton.mouseChildren = true;
				controlBar.setButton.mouseEnabled = true;
				controlBar.setButton.mouseChildren = true;
			}else {
				controlBar.bitrateButton.mouseEnabled = false;	
				controlBar.bitrateButton.mouseChildren = false;
				controlBar.setButton.mouseEnabled = false;	
				controlBar.setButton.mouseChildren = false;
			}
			controlBar.volume.value = playerProxy.volume;
			controlBar.addEventListener(ControlBar.PLAY_BUTTON_CLICK, 			onPlay);
			controlBar.addEventListener(ControlBar.PAUSE_BUTTON_CLICK, 			onPause);
			controlBar.volume.addEventListener(VolumeBox.VOLUME_CHANGED, 		onChangeVolume);
			controlBar.setButton.addEventListener(MouseEvent.CLICK,				onSetClick);	
			controlBar.bitrateButton.addEventListener(MouseEvent.CLICK, 		onBitrateButtonClick);
			controlBar.enterOrExitFullScreen.addEventListener(MouseEvent.CLICK, onFullScreenClick);
		}
		
		private function onSetClick(event:MouseEvent):void {
			sendNotification(PlayerFacade.POPUP_SETTING_PLAY);		
		}
		
		private function onFullScreenClick(event:MouseEvent):void {
			if(controlBar.stage.displayState == StageDisplayState.FULL_SCREEN) {
				controlBar.stage.displayState = StageDisplayState.NORMAL;
			}else {
				controlBar.stage.displayState = StageDisplayState.FULL_SCREEN;	
			}
		}
		
		private function onBitrateButtonClick(event:MouseEvent):void {
			sendNotification(PlayerFacade.POPUP_SETTING_QUA);	
		}
		
		private function onPlay(event:Event):void {
			sendNotification(PlayerFacade.PLAY);
		}
		
		private function onPause(event:Event):void {
			sendNotification(PlayerFacade.PAUSE);	
		}
		
		private function onChangeVolume(event:Event):void {
			var volume:Number = controlBar.volume.value;
			sendNotification(PlayerFacade.CHANGE_VOLUME, volume);
		}
		
		override public function listNotificationInterests():Array {
			return [
				PlayerProxy.PLAYER_STATE_CHANGED,
				PlayerProxy.VIDEO_INFO_RESULT,
				PlayerProxy.VIDEO_BITRATE_INFO_RESULT,
				PlayerProxy.VIDEO_PLAY_PLAYHEAD,
				PlayerProxy.VIDEO_BITRATE_CHANGED
			];
		}
		
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case PlayerProxy.PLAYER_STATE_CHANGED: {
					if(playerProxy.playerState == PlayerState.PLAYING) {
						controlBar.playOrPause.isOn = false;	
					}else {
						controlBar.playOrPause.isOn = true;	
					}
					if(playerProxy.playerState == PlayerState.PLAYING || playerProxy.playerState == PlayerState.PAUSE) {
						controlBar.bitrateButton.mouseEnabled = true;
						controlBar.bitrateButton.mouseChildren = true;
						controlBar.setButton.mouseEnabled = true;
						controlBar.setButton.mouseChildren = true;
					}else {
						controlBar.bitrateButton.mouseEnabled = false;	
						controlBar.bitrateButton.mouseChildren = false;
						controlBar.setButton.mouseEnabled = false;
						controlBar.setButton.mouseChildren = false;
					}
					break;
				}
				case PlayerProxy.VIDEO_INFO_RESULT: {
					totalTime = playerProxy.totalTime;
					break;
				}
				case PlayerProxy.VIDEO_BITRATE_INFO_RESULT: {
					var bitrate:BitrateVO = note.getBody() as BitrateVO;
					controlBar.bitrateButton.bitrate = bitrate;
					break;
				}
				case PlayerProxy.VIDEO_PLAY_PLAYHEAD: {
					var time:Number = note.getBody() as Number;
					playTime = time;
					break;
				}
				case PlayerProxy.VIDEO_BITRATE_CHANGED: {
					var bitrateVO:BitrateVO = note.getBody() as BitrateVO;
					controlBar.bitrateButton.bitrate = bitrateVO;
					break;
				}
			}
		}
		
		private function set totalTime(time:Number):void {
			_totalTimeStr = PlayerUtil.formatTime(time);
			controlBar.updateTime(PlayerUtil.formatTime(0) + " / " + _totalTimeStr);
		}
		
		private function set playTime(time:Number):void {
			controlBar.updateTime(PlayerUtil.formatTime(time) + " / " + _totalTimeStr);
		}
		
		private function get controlBar():ControlBar {
			return viewComponent as ControlBar;
		}
		
	}
}