package com.shen.player.view.ui.setting {
	
	import com.shen.player.model.vo.BitrateVO;
	import com.shen.player.model.vo.CHSBVO;
	import com.shen.uicomps.components.Button;
	import com.shen.uicomps.components.Label;
	import com.shen.uicomps.components.SkinnableComponent;
	import com.shen.uicomps.components.skin.ButtonSkin;
	import com.shen.uicomps.components.skin.Skin;
	
	import flash.display.Sprite;
	
	public class SettingPopup extends Sprite {
		
		private var paddingTop:Number = 10;
		private var paddingBottom:Number = 12;
		private var submitX:Number = 80;
		private var background:SkinnableComponent;
		private var title:Label;
		public var closeButton:Button;
		public var submit:Button;
		public var cancel:Button;
		public var tabNavigator:TabNavigator;
		
		public function SettingPopup() {
			background = new SkinnableComponent();
			background.skin = new Skin(new SettingBgAsset());
			addChild(background);
			
			title = new Label();
			title.text = "设置";
			title.fontFamily = "Microsoft YaHei";
			title.textColor = 0xFFFFFF;
			title.textSize = 14;
			addChild(title);
			title.x = 5;
			title.y = 5;
			
			closeButton = new Button();
			closeButton.skin = new ButtonSkin(new CloseButtonAsset());
			addChild(closeButton);
			
			tabNavigator = new TabNavigator();
			addChild(tabNavigator);
			tabNavigator.x = (background.width - tabNavigator.width) / 2;
			tabNavigator.y = background.height - tabNavigator.height - paddingBottom;
			
			closeButton.x = background.width - tabNavigator.x - closeButton.width;
			closeButton.y = paddingTop;
			
			submit = new Button();
			submit.skin = new ButtonSkin(new SettingButtonAsset());
			addChild(submit);
			submit.width = 70;
			submit.height = 26;
			submit.label = "确定";
			submit.x = submitX;
			submit.y = tabNavigator.y + tabNavigator.height - submit.height - 16;
			
			cancel = new Button();
			cancel.skin = new ButtonSkin(new SettingButtonAsset());
			addChild(cancel);
			cancel.width = 70;
			cancel.height = 26;
			cancel.label = "取消";
			cancel.x = background.width - cancel.width - submitX;
			cancel.y = submit.y;
		}
		
		public function set bitrates(bitrates:Vector.<BitrateVO>):void {
			tabNavigator.settingQualityBox.bitrates = bitrates;
		}
		
public function get thebitrates():Array {
	return tabNavigator.settingQualityBox.thebitrates;
}
		
		public function set selectBitrate(bitrate:Number):void {
			tabNavigator.settingQualityBox.selectBitrate = bitrate;
		}
		
		public function set bitrate(bitrate:Number):void {
			tabNavigator.settingQualityBox.bitrate = bitrate;
		}
		
		public function set autoBitrate(value:Boolean):void {
			tabNavigator.settingQualityBox.autoBitrate = value;
		}
		
		public function set chsb(chsbVO:CHSBVO):void {
			tabNavigator.settingCHSBBox.chsbVO = chsbVO;	
		}
		
		public function get chsb():CHSBVO {
			return tabNavigator.settingCHSBBox.chsbVO;
		}
		
		public function get selectBitrate():Number {
			return tabNavigator.settingQualityBox.selectBitrate;
		}
		
		public function selectPlay():void {
			tabNavigator.selectPlay();
		}
		
		public function selectQua():void {
			tabNavigator.selectQua();
		}
		
		public function selectCHSB():void {
			tabNavigator.selectCHSB();
		}
		
		public function get playSelected():Boolean {
			return 	tabNavigator.selectTabButton == tabNavigator.playTabButton;
		}
		
		public function get quaSelected():Boolean {
			return 	tabNavigator.selectTabButton == tabNavigator.qualityTabButton;
		}
		
		public function get chsbSelected():Boolean {
			return 	tabNavigator.selectTabButton == tabNavigator.chsbTabButton;
		}
	}
}



















