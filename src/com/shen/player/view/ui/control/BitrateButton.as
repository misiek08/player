package com.shen.player.view.ui.control {
	
	import com.shen.player.model.vo.BitrateVO;
	import com.shen.uicomps.components.Button;
	import com.shen.uicomps.components.Label;
	import com.shen.uicomps.components.skin.ButtonSkin;
	
	import flash.events.MouseEvent;
	
	public class BitrateButton extends Button {
		
		private var bitrateLabel:Label;
		private var _bitrate:BitrateVO;
		
		public function BitrateButton() {
			
		}
		
		override public function set skin(buttonSkin:ButtonSkin):void {
			super.skin = buttonSkin;
			if(!bitrateLabel) {
				bitrateLabel = new Label();
				bitrateLabel.textColor = 0xCCCCCC;
			}
			addChild(bitrateLabel);
			bitrateLabel.x = (buttonSkin.width - bitrateLabel.width) / 2;
			bitrateLabel.y = (buttonSkin.height - bitrateLabel.height) / 2;
			addEventListener(MouseEvent.ROLL_OVER, 	onRollOver);	
			addEventListener(MouseEvent.ROLL_OUT,  	onRollOut);	
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,   onMouseUp);
		}
		
		public function set bitrate(bitrate:BitrateVO):void {
			_bitrate = bitrate;
			var myPattern:RegExp = /\s*/g;  
			bitrateLabel.text = _bitrate.label.replace(myPattern, "");
			bitrateLabel.textColor = 0xCCCCCC;
			bitrateLabel.x = (skin.width - bitrateLabel.width) / 2;
			bitrateLabel.y = (skin.height - bitrateLabel.height) / 2;
		}
		
		private function onRollOver(event:MouseEvent):void {
			bitrateLabel.textColor = 0xFFFFFF;
		}
		
		private function onRollOut(event:MouseEvent):void {
			bitrateLabel.textColor = 0xCCCCCC;
			bitrateLabel.x = (skin.width - bitrateLabel.width) / 2;
			bitrateLabel.y = (skin.height - bitrateLabel.height) / 2;
		}
		
		private function onMouseDown(event:MouseEvent):void {
			bitrateLabel.x += 1;
			bitrateLabel.y += 1;
		}
		
		private function onMouseUp(event:MouseEvent):void {
			bitrateLabel.textColor = 0xFFFFFF;
			bitrateLabel.x = (skin.width - bitrateLabel.width) / 2;
			bitrateLabel.y = (skin.height - bitrateLabel.height) / 2;
		}
	}
}
















