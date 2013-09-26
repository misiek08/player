package com.shen100.player.utils {
	
	import flash.external.ExternalInterface;
	
	public class JavaScriptUtil {
	
		private static var _jsAvailable:Boolean = false;
		
		//代码块中的代码只会执行一次，和定义类的属性一样
		{
			try {
				_jsAvailable = ExternalInterface.call("function(){return true;}");	
			}catch(e:SecurityError) {
				_jsAvailable = false;	
			}	
		}
		
		public static function get jsAvailable():Boolean {
			return _jsAvailable;
		}
		
		//浏览器地址栏的URL
		public static function get location():String {
			if(jsAvailable) {
				return ExternalInterface.call("function(){return location.href;}");	
			}else {
				return "";
			}
		}
		
		/**
		 * 访客来源网址
		 * 例如从http://localhost/test/1.html点击按钮，跳转到http://www.shen.com
		 * 那么document.referrer为http://localhost/test/1.html
		 */
		public static function get referrer():String {
			if(jsAvailable) {
				return ExternalInterface.call("function(){return document.referrer;}");
			}else {
				return "";
			}	
		}
		
		//判断用户使用的浏览器与操作系统
		public static function get userAgent():String {
			if(jsAvailable) {
				return ExternalInterface.call("function(){return navigator.userAgent;}");
			}else {
				return "";
			}	
		}
		
		//域名
		public static function get domain():String {
			if(jsAvailable) {
				return ExternalInterface.call("function(){return document.domain;}");
			}else {
				return "";
			}	
		}
		
		//网站的标题
		public static function get title():String {
			if(jsAvailable) {
				return ExternalInterface.call("function(){return document.title;}");
			}else {
				return "";
			}	
		}
		
		public static function openWindow(url:String, width:Number, height:Number, top:Number=0, left:Number=0):void {
			if(jsAvailable) {
				var func:String = "function(){ window.open ('{url}', " 
									+ "'newwindow', 'height={height}, width={width}, title=aaa"
									+ "top={top}, left={left}, toolbar=no, menubar=no, "
									+ "scrollbars=no,resizable=no,location=no, status=no');}"; 
				func = func.replace("{url}", 	url);
				func = func.replace("{width}", 	width);
				func = func.replace("{height}", height);
				func = func.replace("{top}", 	top);
				func = func.replace("{left}", 	left);
				trace(func);
				ExternalInterface.call(func);
			}
		}
		
		//改变flash尺寸大小
		public static function setPlayerSize(width:Number, height:Number):void {
			if(jsAvailable) {
				ExternalInterface.call("setSize", width, height);
			}	
		}
		
		//开灯
		public static function turnOn():void {
			if(jsAvailable) {
				ExternalInterface.call("turnon");
			}	
		}
		
		//关灯
		public static function turnOff():void {
			if(jsAvailable) {
				ExternalInterface.call("turnoff");
			}	
		}
		
		public static function call(functionName:String, ...arguments):* {
			if(jsAvailable) {
				var args:Array = arguments;
				args.unshift(functionName);
				return ExternalInterface.call.apply(null, args);
			}else {
				return undefined;	
			}
		}
	}
}











