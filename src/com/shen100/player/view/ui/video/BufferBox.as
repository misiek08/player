package com.shen100.player.view.ui.video {
	
	import com.shen100.uicomps.components.Label;
	import com.shen100.uicomps.components.SkinnableComponent;
	import com.shen100.uicomps.components.skin.Skin;
	
	import flash.display.Sprite;
	
	public class BufferBox extends Sprite {
		
		private var loading:SkinnableComponent;
		private var _percent:Label;
		
		public function BufferBox() {
			loading = new SkinnableComponent();
			loading.skin = new Skin(new LoadingAsset());
			addChild(loading);
			
			_percent = new Label();
			addChild(_percent);
			_percent.textColor = 0xFFFFFF;
		}
		
		public function set bufferPercent(value:int):void {
			_percent.text = value.toString() + "%";
			_percent.x =  - _percent.width / 2;
			_percent.y = - _percent.height / 2;
		}
	}
}






