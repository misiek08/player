package com.shen100.player.managers {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class PopUpManager {
		
		public function PopUpManager() {
			throw new TypeError("PopUpManager 不是构造函数。");
		}
		
		private static var _stage:Stage;
		
		private static var _window:DisplayObject;
		private static var _parent:DisplayObject;
		
		/**
		 * @param window 要弹出的 DisplayObjectContainer
		 * @param parent 确定居中新的顶级窗口所用的参考点, 它可能并非弹出窗口的实际父项
		 * @param modal  如果为 true，则该窗口为模态窗口，也就是说在删除该窗口之前，用户将无法与其他弹出窗口交互
		 * */
		public static function addPopUp(window:DisplayObjectContainer, 
										parent:DisplayObject,
										modal:Boolean = false):void {
			_window = window;
			_parent = parent;
			_stage  = parent.stage;
			_stage.addEventListener(Event.RESIZE, onResize);
			_stage.addChild(_window);
			onResize();
		}
		
		public static function removePopUp(window:DisplayObjectContainer):void {
			if(_window && _window == window) {
				_stage.removeChild(_window);
				_stage.removeEventListener(Event.RESIZE, onResize);
				_window = null;
				_parent = null;
				_stage  = null;
			}
		}
		
		private static function onResize(event:Event=null):void {
			_window.x = (_parent.width  - _window.width)  / 2;
			_window.y = (_parent.height - _window.height) / 2;
		}
	}
}











