package com.shen.player.controller {
	
	import com.shen.player.model.PlayerProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class LoadVideoInfoCommand extends SimpleCommand  {

		override public function execute( note:INotification ) : void {
			var vid:String = note.getBody() as String;
			var playerProxy:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			playerProxy.loadVideoInfo(vid);
		}
	}
}




















