package com.shen100.player.controller {
	
	import com.shen100.player.model.DwtrackingLogProxy;
	import com.shen100.player.model.HotVideosProxy;
	import com.shen100.player.model.LayoutProxy;
	import com.shen100.player.model.PlayerProxy;
	import com.shen100.player.model.SharedObjectProxy;
	import com.shen100.player.model.SystemProxy;
	import com.shen100.player.model.constant.VideoScaleMode;
	import com.shen100.player.model.vo.CHSBVO;
	import com.shen100.player.model.vo.SettingVO;
	
	import flash.net.registerClassAlias;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ModelPrepCommand extends SimpleCommand  {
		
		override public function execute( note:INotification ) : void {
			var app:Player = note.getBody() as Player;
			var data:Object = app.data;
			registerClassAlias("com.shen.player.model.vo.SettingVO", 	SettingVO);
			registerClassAlias("com.shen.player.model.vo.CHSBVO", 		CHSBVO);
			var playerProxy:PlayerProxy  			= new PlayerProxy();
			var systemProxy:SystemProxy  			= new SystemProxy();
			var layoutProxy:LayoutProxy  			= new LayoutProxy();
			var sharedObjProxy:SharedObjectProxy	= new SharedObjectProxy();
			
			facade.registerProxy( systemProxy );
			facade.registerProxy( layoutProxy );
			facade.registerProxy( playerProxy );
			facade.registerProxy( sharedObjProxy );
			facade.registerProxy( new HotVideosProxy() );
			facade.registerProxy( new DwtrackingLogProxy() );
			
			var version:int = sharedObjProxy.version;
			if(!version) {
				sharedObjProxy.version = sharedObjProxy.newVersion;
			}else if(version < sharedObjProxy.newVersion) {
				sharedObjProxy.clear();	
				sharedObjProxy.version = sharedObjProxy.newVersion;
			}
	
			var settingVO:SettingVO = sharedObjProxy.settingVO;
			if(settingVO && settingVO.chsb) {
				playerProxy.chsbVO = settingVO.chsb;
			}else {
				playerProxy.chsbVO = new CHSBVO();	
			}
			
			if(settingVO && !isNaN(settingVO.bitrate)) {
				playerProxy.selectBitrate = settingVO.bitrate;
				playerProxy.ifAutoBitrate = false;
			}else {
				playerProxy.ifAutoBitrate = true;	
			}
			
			
			
			playerProxy.vid				 = data.vid;
			playerProxy.ifPreload 		 = data.preload    == "0" ? false : true;
			playerProxy.ifAutoPlay 		 = data.autoPlay   == "1" ? true  : false;  
			playerProxy.ifOpenStageVideo = data.stageVideo == "1" ? true  : false;
			playerProxy.ifOpenYunfan 	 = data.yunfan 	   == "1" ? true  : false;
			
			layoutProxy.ifSideBar 		 = data.sideBar     == "0" ? false : true;
			layoutProxy.ifControlBar 	 = data.controlBar  == "0" ? false : true;
			layoutProxy.ifProgressBar 	 = data.progressBar == "0" ? false : true;
			layoutProxy.videoScaleMode 	 = data.scaleMode == "2"    ? VideoScaleMode.CLIP
										    : (data.scaleMode == "3" ? VideoScaleMode.FILL 
										    : VideoScaleMode.FIT);
			
			systemProxy.version = Capabilities.version;
			systemProxy.ifDebug = data.ifDebug	== "1" ? true : false;
			if(app.parent != app.stage) {	//播放器是其它swf的子swf时，禁用stageVideo
				systemProxy.stageVideoSupported = false;	
			}else {
				try{
					var StageVideo:Class = getDefinitionByName(SystemProxy.STAGE_VIDEO) as Class;
					var StageVideoEvent:Class = getDefinitionByName(SystemProxy.STAGE_VIDEO_EVENT) as Class;
					var StageVideoAvailability:Class = getDefinitionByName(SystemProxy.STAGE_VIDEO_AVAILABILITY) as Class;
					var StageVideoAvailabilityEvent:Class = getDefinitionByName(SystemProxy.STAGE_VIDEO_AVAILABILITY_EVENT) as Class;                  
					//flash player 10.2以上，且页面wmode="direct"时，支持StageVideo(AIR版本又不一样，考虑到将来兼容AIR，所以做如下判断)
					if(StageVideo && StageVideoEvent && StageVideoAvailability && StageVideoAvailabilityEvent) {
						systemProxy.stageVideoSupported = true;
					}else {
						systemProxy.stageVideoSupported = false;	
					}
				}catch(err:Error) {
					systemProxy.stageVideoSupported = false;	
				}
			}
		}
	}
}
























