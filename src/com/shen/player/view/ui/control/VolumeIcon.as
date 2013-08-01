package com.shen.player.view.ui.control {
	
	import com.shen.player.view.skin.VolumeIconSkin;
	
	import flash.display.Sprite;
	
	public class VolumeIcon extends Sprite{
	
		private var _skin:VolumeIconSkin;
		
		public function VolumeIcon() {
			
		}
		
		public function get skin():VolumeIconSkin {
			return _skin;
		}
		
		public function set skin(value:VolumeIconSkin):void {
			if(_skin) {
				removeChild(_skin);	
			}
			_skin = value;
			addChild(_skin);
		}
		
		public function set value(value:Number):void {	//  0 <= value <= 1
			var data:Number = Math.round(value * 100 / 25);	//data为0, 1, 2, 3, 4
			if(!data && value) {	//只有value等于0时，data才等于0
				data = 1;
			}
			_skin.value = data * 25;
		} 
		
	}
}













