package com.shen.player.controller {
	
	import com.shen.player.config.ApplicationConfig;
	import com.shen.player.model.DwtrackingLogProxy;
	import com.shen.player.model.PlayerProxy;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class DwtrackingLogCommand extends SimpleCommand {
		
		private var action:String		= "action";
		private var byteload:String		= "byteload";
		private var bytetotal:String	= "bytetotal";
		private var cid:String			= "cid";
		private var clientTime:String	= "clientTime";
		private var frombd:String		= "frombd";
		private var kps:String			= "kps";
		private var mediasrc:String		= "mediasrc";
		private var percent:String		= "percent";
		private var pid:String			= "pid";
		private var playtimes:String	= "playtimes";
		private var refer:String		= "refer";
		private var rnd:String			= "rnd";
		private var uid:String			= "uid";
		private var url:String			= "url";
		private var uuid:String			= "uuid";
		private var ver:String			= "ver";
		private var vid:String			= "vid";
		private var vtime:String		= "vtime";
		private var wnd:String			= "wnd";

		private var playerProxy:PlayerProxy;
		
		override public function execute( note:INotification ) : void {
			playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			switch(note.getBody()) {
				case DwtrackingLogProxy.VIEW: {
					var logParam:Array = [
							cid,
							clientTime,
							frombd,
							kps,
							mediasrc,
							percent,
							pid,
							playtimes,
							refer,
							rnd,
							uid,
							url,
							uuid,
							ver,
							vid,
							vtime,
							wnd
					];
					if(playerProxy.ifOpenYunfan) {
						logParam.push(byteload);
						logParam.push(bytetotal);
					}
					send( DwtrackingLogProxy.VIEW, logParam);
					break;
				}
			}
		}
		
		private function send(actionType:String, logParams:Array):void {
			var ifLog:Object = {};
			for each (var param:String in logParams) {
				ifLog[param] = 1;		
			}
			var request:URLRequest = new URLRequest();
			var theUrl:String = ApplicationConfig.dwtrackingUrl;
			var urlVars:URLVariables = new URLVariables();
			urlVars[action] = actionType;
			
			theUrl += "?" + action + "=" + actionType;
			
			if(ifLog[byteload]) {
				//urlVars[byteload] = "";
				theUrl = addParam(theUrl, byteload, playerProxy.p2pDownload.toString());
			}
			if(ifLog[bytetotal]) {
				//urlVars[bytetotal] 	= "";
				theUrl = addParam(theUrl, bytetotal, playerProxy.httpDownload.toString());
			}
			if(ifLog[cid]) {
				//urlVars[cid] 	= "";
				theUrl = addParam(theUrl, cid, "");
			}
			if(ifLog[clientTime]) {
				//urlVars[clientTime] 	= "";
				theUrl = addParam(theUrl, clientTime, "");
			}
			if(ifLog[frombd]) {
				//urlVars[frombd] 	= "";
				theUrl = addParam(theUrl, frombd, "");
			}
			if(ifLog[kps]) {
				//urlVars[kps] 	= "";
				theUrl = addParam(theUrl, kps, "");
			}
			if(ifLog[mediasrc]) {
				//urlVars[mediasrc] 	= "";
				theUrl = addParam(theUrl, mediasrc, "");
			}
			if(ifLog[percent]) {
				//urlVars[percent] 	= "";
				theUrl = addParam(theUrl, percent, "");
			}
			if(ifLog[pid]) {
				//urlVars[pid] 	= "";
				theUrl = addParam(theUrl, pid, "");
			}
			if(ifLog[playtimes]) {
				//urlVars[playtimes] 	= "";
				theUrl = addParam(theUrl, playtimes, "");
			}
			if(ifLog[refer]) {
				//urlVars[refer] 	= "";
				theUrl = addParam(theUrl, refer, "");
			}
			if(ifLog[rnd]) {
				//urlVars[rnd] 	= "";
				theUrl = addParam(theUrl, rnd, "");
			}
			if(ifLog[uid]) {
				//urlVars[uid] 	= "";
				theUrl = addParam(theUrl, uid, "");
			}
			if(ifLog[theUrl]) {
				//urlVars[url] 	= "";
				theUrl = addParam(theUrl, url, "");
			}
			if(ifLog[uuid]) {
				//urlVars[uuid] 	= "";
				theUrl = addParam(theUrl, uuid, "");
			}
			if(ifLog[ver]) {
				//urlVars[ver] 	= "";
				theUrl = addParam(theUrl, ver, "");
			}
			if(ifLog[vid]) {
				//urlVars[vid] 	= "";
				theUrl = addParam(theUrl, vid, "");
			}
			if(ifLog[vtime]) {
				//urlVars[vtime] 	= "";
				theUrl = addParam(theUrl, vtime, "");
			}
			if(ifLog[wnd]) {
				//urlVars[wnd] 	= "";
				theUrl = addParam(theUrl, wnd, "");
			}
			trace(urlVars.toString());
			//request.data = urlVars;
			request.url = theUrl;
			sendToURL(request);
		}
		
		private function addParam(url:String, key:String, value:String):String {
			url += ("&" + key + "=" + value);
			return url;
		}
		
	}
}