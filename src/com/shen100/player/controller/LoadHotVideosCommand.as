package com.shen100.player.controller {
	
	import com.shen100.player.conf.ApplicationConfig;
	import com.shen100.player.model.HotVideosProxy;
	import com.shen100.player.model.PlayerProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class LoadHotVideosCommand extends SimpleCommand  {
		
		override public function execute( note:INotification ) : void {
			var videoProxy:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var hotVideosProxy:HotVideosProxy = facade.retrieveProxy(HotVideosProxy.NAME) as HotVideosProxy;
			var url:String = ApplicationConfig.hotVideosUrl;
			url = url.replace("{count}", hotVideosProxy.count);
			url = url.replace("{cid}", videoProxy.cid);
			hotVideosProxy.loadHotVideos(url);
		}
	}
}













