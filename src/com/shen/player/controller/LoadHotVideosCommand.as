package com.shen.player.controller {
	
	import com.shen.player.config.ApplicationConfig;
	import com.shen.player.model.HotVideosProxy;
	import com.shen.player.model.PlayerProxy;
	
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













