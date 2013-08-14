package com.shen100.player.utils {
	
	public class PlayerUtil {
	
		public static function formatTime(time:int):String {
			var hour:int = time / 3600;
			var minute:int = (time - hour * 3600) / 60;
			var second:int = time % 60;
			
			var h:String = (hour >= 0 && hour < 10) 	?  "0" + hour 	 : "" + hour;
			var m:String = (minute >= 0 && minute < 10) ?  "0" + minute  : "" + minute;
			var s:String = (second >= 0 && second < 10) ?  "0" + second  : "" + second;

			if(hour > 0) {
				return h + ":" + m + ":" + s;	
			}else {
				return m + ":" + s;	
			}
		}
		
		public function PlayerUtil() {
			throw new TypeError("PlayerUtil 不是构造函数。")
		}
		
	}
}










