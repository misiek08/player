package com.shen.player.view.ui.control {
	
	import com.shen.player.view.skin.VolumeIconSkin;
	import com.shen.uicomps.components.Button;
	import com.shen.uicomps.components.SkinnableComponent;
	import com.shen.uicomps.components.skin.ButtonSkin;
	import com.shen.uicomps.components.skin.Skin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class VolumeBox extends Sprite {
		
		public static const VOLUME_CHANGED:String 	= "volumeChanged";
		
		private var background:SkinnableComponent;
		private var volumeIcon:VolumeIcon;
		private var thumb:Button;
		private var trackBack:SkinnableComponent;
		private var trackFace:SkinnableComponent;
		private var trackFaceMask:Sprite;
		private var volumeProgressBox:Sprite;
		
		private var volumeIconX:Number = 12;
		private var gap:Number = 10;
		private var timer:Timer;
		private var delay:Number = 0.2;
		
		private var _value:Number = 1;
		
		public function VolumeBox() {
			background = new SkinnableComponent();
			background.skin = new Skin(new VolumeBgAsset());
			addChild(background);
			
			volumeIcon = new VolumeIcon();
			volumeIcon.skin = new VolumeIconSkin(new VolumeIconAsset());
			addChild(volumeIcon);
			volumeIcon.x = volumeIconX;
			volumeIcon.y = (background.height - volumeIcon.height) / 2;
			
			volumeProgressBox = new Sprite();
			addChild(volumeProgressBox);
			
			trackBack = new SkinnableComponent();
			trackBack.skin = new Skin(new VolumeTrackBackAsset());
			volumeProgressBox.addChild(trackBack);
			
			trackFace = new SkinnableComponent();
			trackFace.skin = new Skin(new VolumeTrackFaceAsset());
			volumeProgressBox.addChild(trackFace);
		
			thumb = new Button();
			thumb.skin = new ButtonSkin(new VolumeThumbAsset());
			volumeProgressBox.addChild(thumb);
		
			trackFaceMask = new Sprite();
			trackFaceMask.graphics.beginFill(0x000000);
			trackFaceMask.graphics.drawRect(0, 0, trackFace.width, trackFace.height);
			trackFaceMask.graphics.endFill();
			volumeProgressBox.addChild(trackFaceMask);
			
			trackFace.mask = trackFaceMask;
			
			thumb.x = trackBack.width;
			thumb.y = int(trackBack.height / 2);
		
			volumeProgressBox.x = volumeIcon.x + volumeIcon.width + gap;
			volumeProgressBox.y = (background.height - trackBack.height) / 2;
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownThumb);
		}

		private function onMouseDownThumb(event:MouseEvent):void {
			var bounds:Rectangle = new Rectangle(0, thumb.y, trackBack.width, 0);
			thumb.startDrag(false, bounds);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onTimer(event:TimerEvent):void {
			var volume:Number = thumb.x / trackBack.width;
			var e:Event = new Event(VolumeBox.VOLUME_CHANGED);
			_value = volume;
			dispatchEvent(e);
		}
		
		private function onEnterFrame(event:Event):void {
			trackFaceMask.width = thumb.x;
			var value:Number = thumb.x / trackBack.width;
			volumeIcon.value = value;
		}
		
		private function onMouseUpStage(event:MouseEvent):void {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
			thumb.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}	
		
		public function get value():Number {
			return _value;
		}
		
		public function set value(value:Number):void {
			_value = value;
			thumb.x = trackBack.width * value;
			trackFaceMask.width = thumb.x;
			volumeIcon.value = value;
		}
	}
}






















