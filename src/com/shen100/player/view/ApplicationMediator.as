package com.shen100.player.view {
	
	import com.shen100.core.logging.Log;
	import com.shen100.player.PlayerFacade;
	import com.shen100.player.model.PlayerProxy;
	import com.shen100.player.view.ui.control.ControlBar;
	import com.shen100.player.view.ui.control.ProgressBar;
	import com.shen100.player.view.ui.side.SideBar;
	
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "ApplicationMediator";
		
		private var playerProxy:PlayerProxy;
		
		public function ApplicationMediator(viewComponent:Player) {
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			app.play 			= play;
			app.pause 			= pause;
			app.resume 			= resume;
			app.setPlayerSize 	= app.setSize;
			
			playerProxy = facade.retrieveProxy( PlayerProxy.NAME) as PlayerProxy;
			app.playerState = playerProxy.playerState;
			var menu:ContextMenu = app.contextMenu
			if(!menu) {
				menu = new ContextMenu();
			}
			var menuItem:ContextMenuItem = new ContextMenuItem(playerProxy.version, false, false);
			menu.customItems.push(menuItem);
			menu.hideBuiltInItems();
			app.contextMenu = menu;
			Log.debug(this, playerProxy.version);
		}
		
		public function addRightMenuItem(text:String):void {
			var menu:ContextMenu = app.contextMenu;
			if(!menu) {
				menu = new ContextMenu();
			}
			var menuItem:ContextMenuItem = new ContextMenuItem(text, false, false);
			menu.customItems.push(menuItem);
			menu.hideBuiltInItems();
			app.contextMenu = menu;	
		}
		
		private function play(vid:String):void {
			sendNotification(PlayerFacade.LOAD_VIDEOINFO, vid);
		}
		
		private function pause():void {
			sendNotification(PlayerFacade.PAUSE);
		}
		
		private function resume():void {
			sendNotification(PlayerFacade.RESUME);
		}
		
		override public function listNotificationInterests():Array {
			return [
				PlayerProxy.PLAYER_STATE_CHANGED
			];
		}
		
		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case PlayerProxy.PLAYER_STATE_CHANGED: {
					app.playerState = note.getBody() as String;
					break;
				}
			}
		}
		
		public function createSideBar():void {
			app.sideBar = new SideBar();
			app.addChild(app.sideBar);
			app.setSize(app.playerWidth, app.playerHeight);
		}
		
		public function createProgressBar():void {
			app.progressBar = new ProgressBar();
			app.addChild(app.progressBar);
			app.setSize(app.playerWidth, app.playerHeight);
		}
		
		public function createControlBar():void {
			app.controlBar = new ControlBar();
			app.addChild(app.controlBar);
			app.setSize(app.playerWidth, app.playerHeight);
		}
		
		private function get app():Player {
			return viewComponent as Player;
		}
	}
}


