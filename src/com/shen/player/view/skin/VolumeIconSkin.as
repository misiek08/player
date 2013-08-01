package com.shen.player.view.skin {
	
	import com.shen.uicomps.components.skin.Skin;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class VolumeIconSkin extends Skin {
		
		private var _asset:MovieClip;
		
		public function VolumeIconSkin(asset:MovieClip = null) {
			mouseChildren = false;
			if(asset) {
				_asset = asset;
				addChild(_asset);
			}
		}
		
		public function set value(value:int):void {
			setVisible(_asset.volume0,   false);
			setVisible(_asset.volume25,  false);
			setVisible(_asset.volume50,  false);
			setVisible(_asset.volume75,  false);
			setVisible(_asset.volume100, false);
			switch(value) {	//注意只有case 0有break
				case 0:{
					setVisible(_asset.volume0,    true);
					break;
				}
				case 100:{
					setVisible(_asset.volume100,  true);
				}
				case 75:{
					setVisible(_asset.volume75,   true);
				}
				case 50:{
					setVisible(_asset.volume50,   true);
				}
				case 25:{
					setVisible(_asset.volume25,   true);
				}
			}
		}
		
		private function setVisible(display:DisplayObject, visible:Boolean):void {
			if(display) {
				display.visible = visible; 	
			}
		}
	}
}



