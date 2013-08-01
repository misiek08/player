package com.shen.player.controller
{
	import com.shen.player.model.PlayerProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class ChangeVolumeCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) : void {
			var volume:Number = note.getBody() as Number;
			if(0 <= volume && volume <= 1) {
				var playerProxy:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				playerProxy.volume = volume;
			}
		}
	}
}