package com.shen.player.view.ui.setting {
	
	import com.shen.player.model.vo.BitrateVO;
	import com.shen.uicomps.components.Label;
	import com.shen.uicomps.components.RadioButton;
	import com.shen.uicomps.components.skin.RadioButtonSkin;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SettingQualityBox extends Sprite {
		
		private var leftPadding:Number = 20;
		private var topPadding:Number = 12;
		private var gap:Number = 8;
		private var curLabel:Label;
		private var _bitrate:Label;
		private var selectLabel:Label;
		private var _selectBitrate:Number;
		private var _autoBitrate:Boolean;
		private var autoBitrateRb:RadioButton;
		private var tip:Label;
		
		public function SettingQualityBox() {
			curLabel = new Label();
			curLabel.text = "当前视频画质:";
			curLabel.textSize = 14;
			curLabel.textColor = 0xFFFFFF;
			addChild(curLabel);
			curLabel.x = leftPadding;
			curLabel.y = topPadding;
			
			selectLabel = new Label();
			selectLabel.text = "优先为我选择:";
			selectLabel.textSize = 14;
			selectLabel.textColor = 0xFFFFFF;
			addChild(selectLabel);
			selectLabel.x = leftPadding;
			selectLabel.y = curLabel.y + curLabel.height + gap;
			
			autoBitrateRb = new RadioButton("bitrateRadioButtonGroup", false, onRadioButtonClick);
			autoBitrateRb.skin = new RadioButtonSkin(new RateRadioButtonAsset());
			autoBitrateRb.label = "自动匹配";
			autoBitrateRb.textSize = 14;
			addChild(autoBitrateRb);
			autoBitrateRb.x = leftPadding;
			autoBitrateRb.y = selectLabel.y + selectLabel.height + gap;
			
			tip = new Label();
			tip.textColor = 0xCCCCCC;
			tip.textSize = 14;
			tip.text = "带宽建议：1M选择高清，2M选择超清";
			addChild(tip);
			tip.x = 45;
			tip.y = 123;
		}
		
		public function set bitrates(bitrates:Vector.<BitrateVO>):void {
			var tempX:Number = leftPadding;
			for each(var rateData:BitrateVO in bitrates) {
				var radioButton:RadioButton = new RadioButton("bitrateRadioButtonGroup", false, onRadioButtonClick);
				radioButton.skin = new RadioButtonSkin(new RateRadioButtonAsset());
				radioButton.label = rateData.label;
				radioButton.textSize = 14;
				radioButton.vaule = rateData.value;
				addChild(radioButton);
				radioButton.x = tempX;
				radioButton.y = autoBitrateRb.y + autoBitrateRb.height + gap;;
				tempX += (radioButton.width + 20);
			}
		}
		
public function get thebitrates():Array {
	return RadioButton.buttons;
}
		
		public function onRadioButtonClick(event:MouseEvent):void {
			var radioButton:RadioButton = event.currentTarget as RadioButton;
			if(radioButton.vaule) {
				_selectBitrate = radioButton.vaule as Number;
				_autoBitrate = false;
			}else {
				_selectBitrate = NaN;
				_autoBitrate = true;
			}
		}
		
		public function set selectBitrate(bitrate:Number):void {
			_selectBitrate = bitrate;
			trace("----------------------");
			for each (var radioButton:RadioButton in RadioButton.buttons) {
				if(radioButton.groupName == "bitrateRadioButtonGroup" && radioButton.vaule == bitrate) {
					radioButton.selected = true;	
					break;
				}
			}
			
			for each (var rb:RadioButton in RadioButton.buttons) {
				trace(rb.groupName, rb.label);
			}
		}
		
		public function set bitrate(bitrate:Number):void {
			if(!_bitrate) {
				_bitrate = new Label();
				addChild(_bitrate);
				_bitrate.textSize = 14;
				_bitrate.x = curLabel.x + curLabel.width + 10;
				_bitrate.y = curLabel.y;
			}
			for each (var radioButton:RadioButton in RadioButton.buttons) {
				if(radioButton.groupName == "bitrateRadioButtonGroup" && radioButton.vaule == bitrate) {	
					_bitrate.text = radioButton.label;
					_bitrate.textColor = 0xFFFFFF;
					break;
				}
			}
		}

		public function get selectBitrate():Number {
			return _selectBitrate;
		}
		
		public function get autoBitrate():Boolean {
			return _autoBitrate;
		}
		
		public function set autoBitrate(value:Boolean):void {
			_autoBitrate = value;
			if(_autoBitrate) {
				for each (var radioButton:RadioButton in RadioButton.buttons) {
					if(radioButton.groupName == "bitrateRadioButtonGroup" && !radioButton.vaule) {
						radioButton.selected = true;	
					}
				}	
			}
		}
		
		public function destroy():void {
			RadioButton.deleteGroup("bitrateRadioButtonGroup");
		}
	}
}


