package com.shen100.player.model.constant {
	
	public class VideoScaleMode {
		
		public static const FIT:String 		= "videoScaleModeFit";   //等比缩放,在显示区域内
		public static const CLIP:String 	= "videoScaleModeClip";  //等比缩放，超出显示区域的部分被裁剪
		public static const FILL:String 	= "videoScaleModeFill";  //填充显示区域,　视频会被拉伸
		
		public function VideoScaleMode() {
			throw new TypeError("VideoScaleMode 不是构造函数。");	
		}
		
	}
}