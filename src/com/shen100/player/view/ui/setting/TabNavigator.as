package com.shen100.player.view.ui.setting {
	
	import com.shen100.player.view.events.PlayerEvent;
	import com.shen100.uicomps.components.Button;
	import com.shen100.uicomps.components.SkinnableComponent;
	import com.shen100.uicomps.components.skin.ButtonSkin;
	import com.shen100.uicomps.components.skin.Skin;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class TabNavigator extends Sprite{
		
		private var paddingLeft:Number = 10;
		private var gap:Number = 5;
		
		public var chsbTabButton:Button;
		public var playTabButton:Button;
		public var qualityTabButton:Button;
		public var selectTabButton:Button;
		
		private var contentBg:SkinnableComponent;
		public var settingCHSBBox:SettingCHSBBox;
		public var settingPlayBox:SettingPlayBox;
		public var settingQualityBox:SettingQualityBox;
		
		private var tabDict:Dictionary;
		
		public function TabNavigator() {
			tabDict = new Dictionary();
			chsbTabButton = new Button();
			chsbTabButton.skin = new ButtonSkin(new TabScreenshotsButtonAsset());
			addChild(chsbTabButton);
			chsbTabButton.x = paddingLeft;
			
			playTabButton = new Button();
			playTabButton.skin = new ButtonSkin(new TabPlayButtonAsset());
			addChild(playTabButton);
			playTabButton.x = chsbTabButton.x + chsbTabButton.width + gap;
			
			qualityTabButton = new Button();
			qualityTabButton.skin = new ButtonSkin(new TabQuaButtonAsset());
			addChild(qualityTabButton);
			qualityTabButton.x = playTabButton.x + playTabButton.width + gap; 
			
			contentBg = new SkinnableComponent();
			contentBg.skin = new Skin(new TabNavigatorContentAsset());
			addChild(contentBg);
			contentBg.y = qualityTabButton.y + qualityTabButton.height - 1;
			
			chsbTabButton.addEventListener(MouseEvent.MOUSE_UP, 	onUp);
			playTabButton.addEventListener(MouseEvent.MOUSE_UP, 	onUp);
			qualityTabButton.addEventListener(MouseEvent.MOUSE_UP,  onUp);
			
			createNavigatorContent();
			
			tabDict[chsbTabButton] 		= settingCHSBBox;
			tabDict[playTabButton] 		= settingPlayBox;
			tabDict[qualityTabButton] 	= settingQualityBox;
			tab(chsbTabButton);
		}
		
		private function createNavigatorContent():void {
			settingCHSBBox = new SettingCHSBBox();
			settingCHSBBox.x = contentBg.x;
			settingCHSBBox.y = contentBg.y;
			
			settingPlayBox = new SettingPlayBox();
			settingPlayBox.x = contentBg.x;
			settingPlayBox.y = contentBg.y;
			
			settingQualityBox = new SettingQualityBox();
			settingQualityBox.x = contentBg.x;
			settingQualityBox.y = contentBg.y;
			
			settingCHSBBox.addEventListener(PlayerEvent.CHANGE_CHSB, onCHSBChange);
		}
		
		private function onCHSBChange(event:PlayerEvent):void {
			dispatchEvent(event);	
		}
		
		private function onUp(event:MouseEvent):void {
			var tabButton:Button = event.currentTarget as Button;
			tab(tabButton);
		}
		
		public function selectPlay():void {
			tab(playTabButton);	
		}
		
		public function selectQua():void {
			tab(qualityTabButton);	
		}
		
		public function selectCHSB():void {
			tab(chsbTabButton);	
		}
		
		private function tab(tabButton:Button):void {
			if(selectTabButton) {
				setChildIndex(selectTabButton, 0);
				removeChild(tabDict[selectTabButton]);	
				selectTabButton.currentState = "up";
				selectTabButton.mouseEnabled = true;	
				selectTabButton.mouseChildren = true;
			}
			selectTabButton = tabButton;
			tabButton.mouseEnabled = false;
			qualityTabButton.mouseChildren = false;
			addChild(tabButton);
			
			tabButton.currentState = "down";
			addChild(tabDict[tabButton]);	
		}
	}
}

















