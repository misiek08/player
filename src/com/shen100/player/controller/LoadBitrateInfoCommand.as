package com.shen100.player.controller {
	
	import com.shen100.player.model.PlayerProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class LoadBitrateInfoCommand extends SimpleCommand {
		
		override public function execute( note:INotification ) : void {
			var playerProxy:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			playerProxy.loadBitrateInfo();
		}
		
	}
}