package com.shen100.player.view.ui.setting {
	
	import com.shen100.player.model.vo.CHSBVO;
	import com.shen100.player.view.events.PlayerEvent;
	import com.shen100.uicomps.components.Button;
	import com.shen100.uicomps.components.HScrollBar;
	import com.shen100.uicomps.components.Label;
	import com.shen100.uicomps.components.SkinnableComponent;
	import com.shen100.uicomps.components.skin.ButtonSkin;
	import com.shen100.uicomps.components.skin.ScrollBarSkin;
	import com.shen100.uicomps.components.skin.Skin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SettingCHSBBox extends Sprite {
		
		private var paddingLeft:Number = 42;
		private var paddingTop:Number = 25;
		private var gap:Number = 18;
		private var scrollBarHGap:Number = 20;
		
		private var contrastIcon:SkinnableComponent;	
		private var brightnessIcon:SkinnableComponent;
		private var saturationIcon:SkinnableComponent;
		
		private var contrastLabel:Label;
		private var brightnessLabel:Label;
		private var saturationLabel:Label;
		private var defaultLabel:Label;
		
		private var contrastScrollBar:HScrollBar;
		private var brightnessScrollBar:HScrollBar;
		private var saturationScrollBar:HScrollBar;
		
		private var defaultButton:Button;
		
		private var _chsbVO:CHSBVO;
		
		public function SettingCHSBBox() {
			contrastIcon = new SkinnableComponent();
			contrastIcon.skin = new Skin(new ContrastIconAsset());
			addChild(contrastIcon);
			contrastIcon.x = paddingLeft + contrastIcon.width / 2;
			contrastIcon.y = paddingTop + contrastIcon.height / 2;
			
			contrastLabel = new Label();
			contrastLabel.text = "对比度";
			contrastLabel.textColor = 0xCCCCCC;
			addChild(contrastLabel);
			contrastLabel.x = contrastIcon.x + contrastIcon.width;
			contrastLabel.y = contrastIcon.y - contrastLabel.height / 2;
			
			contrastScrollBar = new HScrollBar();
			contrastScrollBar.skin = new ScrollBarSkin(new SettingScrollBarAsset());
			addChild(contrastScrollBar);
			contrastScrollBar.x = contrastLabel.x + contrastLabel.width + scrollBarHGap;
			contrastScrollBar.y = contrastIcon.y;
			
			brightnessIcon = new SkinnableComponent();
			brightnessIcon.skin = new Skin(new BrightnessIconAsset());
			addChild(brightnessIcon);
			brightnessIcon.x = contrastIcon.x ;
			brightnessIcon.y = contrastIcon.y + contrastIcon.height + gap;
			
			brightnessLabel = new Label();
			brightnessLabel.text = "亮　度";
			brightnessLabel.textColor = 0xCCCCCC;
			addChild(brightnessLabel);
			brightnessLabel.x = brightnessIcon.x + brightnessIcon.width;
			brightnessLabel.y = brightnessIcon.y - brightnessLabel.height / 2;
			
			brightnessScrollBar = new HScrollBar();
			brightnessScrollBar.skin = new ScrollBarSkin(new SettingScrollBarAsset());
			addChild(brightnessScrollBar);
			brightnessScrollBar.x = brightnessLabel.x + brightnessLabel.width + scrollBarHGap;
			brightnessScrollBar.y = brightnessIcon.y;
			
			saturationIcon = new SkinnableComponent();
			saturationIcon.skin = new Skin(new SaturationIconAsset());
			addChild(saturationIcon);
			saturationIcon.x = contrastIcon.x;
			saturationIcon.y = brightnessIcon.y + brightnessIcon.height + gap;
			
			saturationLabel = new Label();
			saturationLabel.text = "饱和度";
			saturationLabel.textColor = 0xCCCCCC;
			addChild(saturationLabel);
			saturationLabel.x = saturationIcon.x + saturationIcon.width;
			saturationLabel.y = saturationIcon.y - saturationLabel.height / 2;
			
			saturationScrollBar = new HScrollBar();
			saturationScrollBar.skin = new ScrollBarSkin(new SettingScrollBarAsset());
			addChild(saturationScrollBar);
			saturationScrollBar.x = saturationLabel.x + saturationLabel.width + scrollBarHGap;
			saturationScrollBar.y = saturationIcon.y;
			
			defaultLabel = new Label();
			defaultLabel.text = "默认值";
			defaultLabel.textColor = 0xCCCCCC;
			addChild(defaultLabel);
			defaultLabel.x = contrastLabel.x;
			defaultLabel.y = saturationIcon.y + saturationIcon.height / 2 + gap;
			
			defaultButton = new Button();
			defaultButton.skin = new ButtonSkin(new SettingButtonAsset());
			addChild(defaultButton);
			defaultButton.label = "恢复";
			defaultButton.textSize = 12;
			defaultButton.x = contrastScrollBar.x;
			defaultButton.y = defaultLabel.y;
			
			contrastScrollBar.addEventListener(Event.CHANGE, 	onCHSBChange);
			saturationScrollBar.addEventListener(Event.CHANGE, 	onCHSBChange);
			brightnessScrollBar.addEventListener(Event.CHANGE, 	onCHSBChange);
			defaultButton.addEventListener(MouseEvent.CLICK, 	onDefaultClick);
		}
	
		private function onCHSBChange(event:Event):void {
			//HScrollBar的取值范围为[0, 1]
			//c, h, s, b的取值范围为[-100, 100]
			//我们把c, h, s, b的范围限制在[-90, 90]
			var contrast:int = contrastScrollBar.value * 180 - 90;
			var hue:int = 0;
			var saturation:int = saturationScrollBar.value * 180 - 90;
			var brightness:int = brightnessScrollBar.value * 180 - 90;
			var chsb:CHSBVO = new CHSBVO(contrast, hue, saturation, brightness);
			_chsbVO = chsb;
			var e:PlayerEvent = new PlayerEvent(PlayerEvent.CHANGE_CHSB);
			e.data = chsb;
			dispatchEvent(e);
		}
		
		private function onDefaultClick(event:MouseEvent):void {
			var chsb:CHSBVO = new CHSBVO();
			chsbVO = chsb;	
			var e:PlayerEvent = new PlayerEvent(PlayerEvent.CHANGE_CHSB);
			e.data = chsb;
			dispatchEvent(e);
		}
		
		public function set chsbVO(chsb:CHSBVO):void {
			_chsbVO = chsb;
			contrastScrollBar.value 	= (chsb.contrast + 90) / 180;
			brightnessScrollBar.value 	= (chsb.brightness + 90) / 180;
			saturationScrollBar.value 	= (chsb.saturation + 90) / 180;	
		}
		
		public function get chsbVO():CHSBVO {
			return _chsbVO;
		}
	}
}











