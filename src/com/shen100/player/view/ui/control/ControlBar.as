package com.shen100.player.view.ui.control {
	
	import com.shen100.uicomps.components.Button;
	import com.shen100.uicomps.components.SkinnableComponent;
	import com.shen100.uicomps.components.ToggleButton;
	import com.shen100.uicomps.components.skin.ButtonSkin;
	import com.shen100.uicomps.components.skin.Skin;
	import com.shen100.uicomps.components.skin.ToggleButtonSkin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ControlBar extends Sprite {
	
		public static const PLAY_BUTTON_CLICK:String 	= "playButtonClick";
		public static const PAUSE_BUTTON_CLICK:String 	= "pauseButtonClick";
	
		private var bg:SkinnableComponent;
		private var timeText:TextField;
		public var enterOrExitFullScreen:ToggleButton;
		//private var recommandButton:Button;
		public var setButton:Button;
		public var bitrateButton:BitrateButton;
		
		public var playOrPause:ToggleButton;
		public var volume:VolumeBox;
		
		public function ControlBar() {
			bg = new SkinnableComponent();
			bg.skin = new Skin(new ControlBarBgAsset());
			addChild(bg);
			
			playOrPause = new ToggleButton();
			var playOrPauseSkin:ToggleButtonSkin = new ToggleButtonSkin(new PlayOrPauseToggleButtonAsset()); 
			playOrPause.skin = playOrPauseSkin;
			addChild(playOrPause);	
			
			timeText = new TextField();
			timeText.autoSize = TextFieldAutoSize.LEFT;
			addChild(timeText);
			timeText.textColor = 0xCCCCCC;
			timeText.text = "00:00" + " / " + "00:00";
			
			enterOrExitFullScreen = new ToggleButton();
			var enterOrExitSkin:ToggleButtonSkin = new ToggleButtonSkin(new EnterOrExitFullScreenToggleButtonAsset());                            
			enterOrExitFullScreen.skin = enterOrExitSkin;
			addChild(enterOrExitFullScreen);
			
			setButton = new Button();
			setButton.skin = new ButtonSkin(new SystemSetButtonAsset());
			addChild(setButton);
			
			bitrateButton = new BitrateButton();
			bitrateButton.skin = new ButtonSkin(new BitrateButtonAsset());
			addChild(bitrateButton);
			
			volume = new VolumeBox();
			addChild(volume);
			
//			recommandButton = new Button();
//			recommandButton.skin = new ButtonSkin(new RecommendButtonAsset());
//			addChild(recommandButton);
			
			invalidate();
			
			playOrPause.addEventListener(ToggleButton.TOGGLE, onPlayOrPauseClick);
		}
		
		private function invalidate():void {
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}
		
		private function onInvalidate(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		
		private function draw():void {
			timeText.x = playOrPause.x + playOrPause.width + 5;
			timeText.y = (height - timeText.height) / 2;
			enterOrExitFullScreen.x = bg.width - enterOrExitFullScreen.width;
			setButton.x = enterOrExitFullScreen.x - setButton.width;
			bitrateButton.x = setButton.x - bitrateButton.width;
//			recommandButton.x = bitrateButton.x - recommandButton.width;
//			volume.x = recommandButton.x - volume.width;
			volume.x = bitrateButton.x - volume.width;
		}
	
		private function onPlayOrPauseClick(event:Event):void {
			if(playOrPause.isOn) {
				dispatchEvent(new Event(PAUSE_BUTTON_CLICK));		
			}else {
				dispatchEvent(new Event(PLAY_BUTTON_CLICK));
			}
		}
		
		public function updateTime(time:String):void {
			timeText.text = time;
		}
		
		override public function set width(value:Number):void {
			bg.width = value;
			draw();
		}
	}
}