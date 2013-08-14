package com.shen100.player.model.vo {
	
	public class CHSBVO {
		
		public var contrast:int;	//[-100, 100]
		public var hue:int;			//[-100, 100]	
		public var saturation:int;	//[-100, 100]
		public var brightness:int;	//[-100, 100]
		
		public function CHSBVO(contrast:int=0, hue:int=0, saturation:int=0, brightness:int=0) {
			this.contrast 	= contrast;
			this.hue 		= hue;
			this.saturation = saturation;
			this.brightness = brightness;
		}
		
		public function equals(chsbVO:CHSBVO):Boolean {
			if(chsbVO && chsbVO.contrast == contrast 
					&& chsbVO.hue == hue 
					&& chsbVO.saturation == saturation 
					&& chsbVO.brightness == brightness) {
				return true;	
			}
			return false;
		}
		
	}
}



