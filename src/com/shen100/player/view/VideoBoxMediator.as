package com.shen100.player.view {
	
	import com.shen100.core.geom.ColorMatrix;
	import com.shen100.player.conf.ApplicationConfig;
	import com.shen100.player.model.LayoutProxy;
	import com.shen100.player.model.PlayerProxy;
	import com.shen100.player.model.SystemProxy;
	import com.shen100.player.model.constant.PlayerState;
	import com.shen100.player.model.vo.CHSBVO;
	import com.shen100.player.view.ui.video.VideoBox;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class VideoBoxMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "VideoBoxMediator";
	
		private var systemProxy:SystemProxy;
		private var layoutProxy:LayoutProxy;
		private var playerProxy:PlayerProxy;
		
		private var StageVideo:Class;
		private var StageVideoEvent:Class;
		private var StageVideoAvailability:Class;
		private var StageVideoAvailabilityEvent:Class;
		
		private var _stageVideo:*;
		
		private var bufferTimer:Timer;
		
		public function VideoBoxMediator(viewComponent:VideoBox) {
			super(NAME, viewComponent);	
		}
		
		override public function onRegister():void {
			systemProxy  = facade.retrieveProxy(SystemProxy.NAME) as SystemProxy;
			layoutProxy  = facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy;
			playerProxy  = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			videoBox.videoScaleMode = layoutProxy.videoScaleMode;
			videoCHSB = playerProxy.chsbVO;
			//系统支持StageVideo时，才监听stageVideo是否可用
			if(systemProxy.stageVideoSupported) {  
				StageVideo = getDefinitionByName(SystemProxy.STAGE_VIDEO) as Class;
				StageVideoEvent = getDefinitionByName(SystemProxy.STAGE_VIDEO_EVENT) as Class;
				StageVideoAvailability = getDefinitionByName(SystemProxy.STAGE_VIDEO_AVAILABILITY) as Class;
				StageVideoAvailabilityEvent = getDefinitionByName(SystemProxy.STAGE_VIDEO_AVAILABILITY_EVENT) as Class;	
				if(videoBox.stage) {
					videoBox.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);	
				}else {
					videoBox.addEventListener(Event.ADDED_TO_STAGE, onVideoBoxAddedToStage);	
				}
				videoBox.addEventListener(Event.REMOVED_FROM_STAGE, onVideoBoxRemovedFromStage);
			}
		}
		
		private function onVideoBoxAddedToStage(event:Event):void {
			videoBox.removeEventListener(Event.ADDED_TO_STAGE, onVideoBoxAddedToStage);
			videoBox.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);
		}
		
		private function onVideoBoxRemovedFromStage(event:Event):void {
			videoBox.removeEventListener(Event.REMOVED_FROM_STAGE, onVideoBoxRemovedFromStage);
			videoBox.stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailability);	
		}
		
		private function onStageVideoAvailability(event:Object):void {
			if(event.availability == StageVideoAvailability.AVAILABLE) {
				if(videoBox.stage["stageVideos"] && videoBox.stage["stageVideos"].length > 0) {
					_stageVideo = videoBox.stage["stageVideos"][0];
				}else {
					_stageVideo = null;	
				}
			}else {
				_stageVideo = null;
			}
			if(playerProxy.ifOpenStageVideo) {
				videoBox.stageVideo = _stageVideo;	
			}else {
				videoBox.stageVideo = null;	
			}
		}
		
		override public function listNotificationInterests():Array {
			return [
						PlayerProxy.PLAYER_STATE_CHANGED,
						PlayerProxy.VIDEO_PLAY_STREAM,
						PlayerProxy.VIDEO_META_DATA,
						PlayerProxy.VIDEO_BUFFER_EMPTY,
						PlayerProxy.VIDEO_BUFFER_FULL,
						PlayerProxy.STAGE_VIDEO_OPENED,
						PlayerProxy.STAGE_VIDEO_CLOSED
				];
		}
		
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case PlayerProxy.PLAYER_STATE_CHANGED: {
					if(playerProxy.playerState == PlayerState.READY) {
						if(!playerProxy.ifAutoPlay) {
							videoBox.imageUrl = playerProxy.bigPicPath;	
						}	
					}else if(playerProxy.playerState == PlayerState.PLAYING) {
						videoBox.removeImage();	
					}
					break;
				}
				case PlayerProxy.VIDEO_PLAY_STREAM: {
					videoBox.videoStream = note.getBody() as NetStream;
					break;
				}
				case PlayerProxy.VIDEO_META_DATA: {
					videoBox.videoMetaData = note.getBody();
					break;
				}
				case PlayerProxy.VIDEO_BUFFER_EMPTY: {
					listenBuffer();
					break;
				}
				case PlayerProxy.VIDEO_BUFFER_FULL: {
					stopListenBuffer();
					break;
				}
				case PlayerProxy.STAGE_VIDEO_OPENED: {
					openStageVideo(true);
					break;
				}
				case PlayerProxy.STAGE_VIDEO_CLOSED: {
					openStageVideo(false);
					break;
				}
			}
		}
		
		private function listenBuffer():void {
			if(!bufferTimer) {
				bufferTimer = new Timer(100);	
			}else {
				bufferTimer.reset();	
			}
			bufferTimer.addEventListener(TimerEvent.TIMER, onBuffer);
			bufferTimer.start();
		}
		
		private function onBuffer(event:TimerEvent):void {
			videoBox.bufferPercent = playerProxy.bufferPercent;		
		}
		
		private function stopListenBuffer():void {
			videoBox.removeBuffer();
			if(bufferTimer) {
				bufferTimer.stop();
				bufferTimer.removeEventListener(TimerEvent.TIMER, onBuffer);
				bufferTimer = null;
			}
		}
		
		private function openStageVideo(value:Boolean):void {
			if(value) {
				videoBox.stageVideo = _stageVideo;	
			}else {
				videoBox.stageVideo = null;	
			}
		}
		
		public function set videoCHSB(chsbVO:CHSBVO):void {
			var cm:ColorMatrix = new ColorMatrix();
			cm.adjustColor(chsbVO.brightness, chsbVO.contrast, chsbVO.saturation, chsbVO.hue);
			videoBox.video.filters = [new ColorMatrixFilter(cm)];	
		}
		
		public function get videoBox():VideoBox {
			return viewComponent as VideoBox;
		}
	}
}










