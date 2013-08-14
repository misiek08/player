package com.shen100.player.model 
{
	import com.shen100.player.model.vo.SettingVO;
	
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class SharedObjectProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "SettingProxy";
		
		public var newVersion:int = 5;
		
		private var sharedObjName:String = "shen_player";
		private var localPath:String = "/";
		
		private var _settingVO:SettingVO;
		
		public function SharedObjectProxy() {
			super(NAME);	
		}
		
		public function get version():int {
			var sharedObj:SharedObject = SharedObject.getLocal(sharedObjName, localPath);
			return sharedObj.data["version"];
		}
		
		public function set version(value:int):void {
			write("version", value);	
		}

		public function get settingVO():SettingVO {
			var sharedObj:SharedObject = SharedObject.getLocal(sharedObjName, localPath);
			return sharedObj.data["setting"];
		}
		
		public function set settingVO(value:SettingVO):void {
			write("setting", value);	
		}
		
		public function write(key:String, value:Object):void {
			var sharedObj:SharedObject = SharedObject.getLocal(sharedObjName, localPath);
			sharedObj.data[key] = value;
			
			var onStatus:Function =  function( event:NetStatusEvent ):void {
				if( event.info.code == "SharedObject.Flush.Success" ) {
					
				}else if ( event.info.code == "SharedObject.Flush.Failed" ) {
					
				}
				sharedObj.removeEventListener( NetStatusEvent.NET_STATUS, onStatus );
			};
			
			try {
				var flushResult:String = sharedObj.flush();	
				if( flushResult == SharedObjectFlushStatus.PENDING ) {
					sharedObj.addEventListener( NetStatusEvent.NET_STATUS, onStatus );	
				}else if( flushResult == SharedObjectFlushStatus.FLUSHED ) {
					
				}
			}catch(e:Error) {
				
			}
		}
		
		public function clear():void {
			var sharedObj:SharedObject = SharedObject.getLocal(sharedObjName, localPath);
			sharedObj.clear();
		}

	}
}