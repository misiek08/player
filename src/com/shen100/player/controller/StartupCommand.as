package com.shen100.player.controller {
	
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	
	public class StartupCommand extends MacroCommand {
		
		override protected function initializeMacroCommand():void {
			addSubCommand(ModelPrepCommand);
			addSubCommand(ViewPrepCommand);
		}
		
	}
}