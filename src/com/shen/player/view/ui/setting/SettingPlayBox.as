package com.shen.player.view.ui.setting {
	
	import com.shen.uicomps.components.CheckBox;
	import com.shen.uicomps.components.skin.CheckBoxSkin;
	
	import flash.display.Sprite;
	
	public class SettingPlayBox extends Sprite {
		
		private var autoPlay:CheckBox;
		private var openStageVideo:CheckBox;
		
		public function SettingPlayBox() {
			autoPlay = new CheckBox();
			autoPlay.skin = new CheckBoxSkin(new SettingCheckBoxAsset());
			autoPlay.label = "始终自动连播";
			addChild(autoPlay);
			autoPlay.x = 110;
			autoPlay.y = 50;
			
			openStageVideo = new CheckBox();
			openStageVideo.skin = new CheckBoxSkin(new SettingCheckBoxAsset());
			openStageVideo.label = "开启显卡加速";
			addChild(openStageVideo);
			openStageVideo.x = autoPlay.x;
			openStageVideo.y = autoPlay.y + 30;
		}
		
	}
}




