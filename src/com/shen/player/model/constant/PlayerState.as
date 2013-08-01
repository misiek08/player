package com.shen.player.model.constant {
	
	public class PlayerState {
		
		public static const PENDING:String     	= "playerStatePending";	//未准备好
		public static const READY:String		= "playerStateReady";	//准备好了，可以播视频
		public static const PRELOAD:String		= "playerStatePreload";	//预加载
		public static const PLAYING:String 		= "playerStatePlaying";	//正在播放
		public static const PAUSE:String 		= "playerStatePause";	//暂停
		public static const STOP:String			= "playerStateStop";	//停止
		
		public function PlayerState() {
			throw new TypeError("PlayerState 不是构造函数。");	
		}
		
	}
}