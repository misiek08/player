package com.shen.player.controller {
	
	import com.shen.player.PlayerFacade;
	import com.shen.player.model.LayoutProxy;
	import com.shen.player.model.PlayerProxy;
	import com.shen.player.model.SystemProxy;
	import com.shen.player.view.ApplicationMediator;
	import com.shen.player.view.ControlBarMediator;
	import com.shen.player.view.ProgressBarMediator;
	import com.shen.player.view.SideBarMediator;
	import com.shen.player.view.VideoBoxMediator;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ViewPrepCommand extends SimpleCommand {
		
		[Embed(source="Yunfan.swf")]
		private var ClassLib:Class;
		private var playerProxy:PlayerProxy;
		
		override public function execute( note:INotification ) : void {
			var app:Player = note.getBody() as Player;
			var appMediator:ApplicationMediator = new ApplicationMediator(app);
			facade.registerMediator( appMediator );
			facade.registerMediator( new VideoBoxMediator(app.videoBox) );
	
			var layoutProxy:LayoutProxy = facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy;
			if(layoutProxy.ifSideBar) {
				appMediator.createSideBar();
				facade.registerMediator( new SideBarMediator(app.sideBar) );
			}
			if(layoutProxy.ifControlBar) {
				appMediator.createControlBar();
				facade.registerMediator( new ControlBarMediator(app.controlBar) );
			}
			if(layoutProxy.ifProgressBar) {
				appMediator.createProgressBar();
				facade.registerMediator( new ProgressBarMediator(app.progressBar) );
			}
			
			playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			
			//开启云帆的功能本应写在ModelPrepCommand里面，但由于loader.loadBytes是异步加载
			//所以写在这里，loader.loadBytes完成之后请求加载视频信息
			if(playerProxy.ifOpenYunfan) {
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
				//可以参考下flex中的mx.core.MovieClipLoaderAsset
				var classLib:* = new ClassLib();
				loader.loadBytes(classLib.movieClipData);
				if(classLib.movieClipData is ByteArray) {
					trace("movieClipData is ByteArray");	
				}
			}else {
				var vid:String = playerProxy.vid;
				sendNotification(PlayerFacade.LOAD_VIDEOINFO, vid);
			}
		}
		
		private function onLoad(event:Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var appDomain:ApplicationDomain = loaderInfo.applicationDomain;	
			var YunfanStream:Class = appDomain.getDefinition(SystemProxy.YunfanStream) as Class; 
			playerProxy.YunfanStream = YunfanStream;
			playerProxy.yunfanNO = YunfanStream.VERSION;
			
			var appMediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			appMediator.addRightMenuItem(playerProxy.yunfanVersion);

			var vid:String = playerProxy.vid;
			sendNotification(PlayerFacade.LOAD_VIDEOINFO, vid);
		}
	}
}


