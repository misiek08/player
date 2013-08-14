package com.shen100.player.view.ui.side {
	
	import com.shen100.uicomps.components.Button;
	import com.shen100.uicomps.components.SkinnableComponent;
	import com.shen100.uicomps.components.ToggleButton;
	import com.shen100.uicomps.components.skin.ButtonSkin;
	import com.shen100.uicomps.components.skin.Skin;
	import com.shen100.uicomps.components.skin.ToggleButtonSkin;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SideBar extends Sprite {
		
		private var background:SkinnableComponent;
		public var screenNormalOrWide:ToggleButton;
		public var windowButton:Button;
		public var turnOnOrOff:ToggleButton;
		public var shareButton:Button;
		
		public function SideBar() {
			background = new SkinnableComponent();
			background.skin = new Skin(new SidebarBgAsset());
			addChild(background);
			
			screenNormalOrWide = new ToggleButton();
			screenNormalOrWide.skin = new ToggleButtonSkin(new SidebarScreenNormalOrWideAsset());
			addChild(screenNormalOrWide);
			
			windowButton = new Button();
			windowButton.skin = new ButtonSkin(new SideBarWindowAsset());
			addChild(windowButton);
			
			turnOnOrOff = new ToggleButton();
			turnOnOrOff.skin = new ToggleButtonSkin(new SidebarLightTurnonOrOffAsset());
			addChild(turnOnOrOff);
			
			shareButton = new Button();
			shareButton.skin = new ButtonSkin(new SideBarShareAsset());
			addChild(shareButton);
			
			var space:Number = (background.height - screenNormalOrWide.height - windowButton.height - turnOnOrOff.height - shareButton.height) / 5;
			screenNormalOrWide.x = (background.width - screenNormalOrWide.width) / 2;
			screenNormalOrWide.y = space;
			
			windowButton.x = (background.width - windowButton.width) / 2;
			windowButton.y = screenNormalOrWide.y + screenNormalOrWide.height + space;
			
			turnOnOrOff.x = (background.width - turnOnOrOff.width) / 2;
			turnOnOrOff.y = windowButton.y + windowButton.height + space;
			
			shareButton.x = (background.width - shareButton.width) / 2;
			shareButton.y = turnOnOrOff.y + turnOnOrOff.height + space;
			
			screenNormalOrWide.addEventListener(MouseEvent.CLICK, 	onScreenClick);
			windowButton.addEventListener(MouseEvent.CLICK, 		onWindowClick);
			turnOnOrOff.addEventListener(MouseEvent.CLICK, 			onTurnOnOrOffClick);
			shareButton.addEventListener(MouseEvent.CLICK, 			onShareClick);
		}
		
		private function onScreenClick(event:MouseEvent):void {
			
		}
	
		private function onWindowClick(event:MouseEvent):void {
			
		}
		
		private function onTurnOnOrOffClick(event:MouseEvent):void {
			
		}
		
		private function onShareClick(event:MouseEvent):void {
			
		}
	}
}


















