package com.shen100.player.model.constant
{
	public class PlayerType
	{
		public static const OUT:String 		= "out";   	//站外播放器
		public static const LIV:String 		= "liv";  	//直播播放器
		
		public function PlayerType() {
			throw new TypeError("PlayerType 不是构造函数。");	
		}
	}
}