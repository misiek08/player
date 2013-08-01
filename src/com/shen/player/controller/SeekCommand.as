package com.shen.player.controller {
	
	import com.shen.player.model.PlayerProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SeekCommand extends SimpleCommand {
		
		override public function execute( note:INotification ) : void    
		{
			var percent:Number = note.getBody() as Number;
			
			var videoProxy:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			
			var time:Number = (videoProxy.totalTime - 1) * percent;
			time = Number(time.toFixed(1));
			trace("SeekCommand: " + time);
			videoProxy.seek(time);
		}
		
	}
}