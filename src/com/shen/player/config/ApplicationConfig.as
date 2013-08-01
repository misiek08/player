package com.shen.player.config {
	
	public class ApplicationConfig {
		
		public static const ALLOW_DOMAIN:Array = ["wedding.shen100.com", "love100.sinaapp.com"];
		
		public static var ku6VideoUrl:String 		= "http://v.ku6.com/show/{vid}.html";
		public static var videoInfoUrl:String 		= "http://v.ku6.com/fetchVideo4Player/{vid}.html";
		public static var hotVideosUrl:String 		= "http://v.ku6.com/fetch.htm?t=getWeeklyHotVideos&p={count}&categoryId={cid}";
		public static var dwtrackingUrl:String 		= "http://dwtracking.sdo.com/ku6.gif";
		public static var windowPlayerUrl:String 	= "http://liushen.sinaapp.com/player/window";
		public static var playerUrl:String 			= "http://liushen.sinaapp.com/player/Player.swf";
		
		public static var shareQzoneUrl:String 		= "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url={url}";
		public static var shareRenrenUrl:String 	= "http://share.xiaonei.com/share/buttonshare.do?link={url}&title={title}";
		public static var shareSinaWeiboUrl:String 	= "http://v.t.sina.com.cn/share/share.php?c=spr_web_bd_ku6_weibo&url={url}"
														+ "&title={title}&source=%E9%85%B76%E7%BD%91&sourceUrl=http%3A%2F%2Fwww.ku6.com%2F" 
														+ "&content=gbk&pic={pic}";      
		public static var shareQQWeiboUrl:String 	= "http://share.v.t.qq.com/index.php?c=share&a=index&title={title}&url={url}&pic={pic}";
		public static var shareKaixinUrl:String 	= "http://www.kaixin001.com/~repaste/repaste.php?rtitle={title}&rurl={url}&rcontent={title}";
		public static var shareQQPengyouUrl:String 	= "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?to=xiaoyou&url={url}";
		public static var shareTianyaUrl:String 	= "http://www.tianya.cn/new/share/compose.asp?itemtype=tech&item=665&strTitle={title}&strFlashURL={swfUrl}&strFlashPageURL={url}&pIMG={pic}&strContent=%E9%85%B76%E7%BD%91";                                    
		public static var shareDoubanUrl:String 	= "http://shuo.douban.com/!service/share?image={pic}&href={url}&name={title}";
		
		public function ApplicationConfig() {
			throw new TypeError("ApplicationConfig 不是构造函数。");
		}
	}
}