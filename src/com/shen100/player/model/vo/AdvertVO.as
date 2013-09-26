package com.shen100.player.model.vo
{
	public class AdvertVO
	{
		private var _hasBeforeAd:Boolean;	//是否有前帖广告
		private var _hasPauseAd:Boolean;	//是否有暂停广告
		private var _hasCornerAd:Boolean;	//是否有角标广告
		private var _hasAfterAd:Boolean;	//是否有后帖广告
		
		public function AdvertVO()
		{
		}
		
		public function set adCode(value:String):void
		{
			var codeArr:Array 	= value.split("");
			_hasBeforeAd 		= codeArr[0] == "1" ? true : false;
			_hasPauseAd	 		= codeArr[1] == "1" ? true : false;
			_hasCornerAd		= codeArr[2] == "1" ? true : false;
			_hasAfterAd			= codeArr[3] == "1" ? true : false;
		}
		
		public function set adStr(value:String):void {
			if( value == "|" ){
				_hasBeforeAd = _hasAfterAd = false;
			}else if( value == "ead" ){
				_hasBeforeAd = false;
			}else if( value == "sad" ){
				_hasAfterAd = false;
			}
		}

		public function get hasBeforeAd():Boolean
		{
			return _hasBeforeAd;
		}

		public function get hasPauseAd():Boolean
		{
			return _hasPauseAd;
		}
		
		public function get hasCornerAd():Boolean
		{
			return _hasCornerAd;
		}

		public function get hasAfterAd():Boolean
		{
			return _hasAfterAd;
		}

	}
}