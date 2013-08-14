package com.shen100.player.view.ui.control {
	
	import caurina.transitions.Tweener;
	
	import com.shen100.uicomps.components.Button;
	import com.shen100.uicomps.components.SkinnableComponent;
	import com.shen100.uicomps.components.skin.ButtonSkin;
	import com.shen100.uicomps.components.skin.Skin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ProgressBar extends Sprite {
		
		public static const DRAG:String 	= "progressBarDrag";
		public static const CLICK:String 	= "progressBarClick";
		
		public var playPercent:Number = 0;	//用户拖拽播放头，或点击进度条时，播放头的位置(百分比)
		public var loadPercent:Number = 0;	//下载到的时间点(百分比)
		
		private var isDraged:Boolean = false;
		private var thumb:Button;
		private var background:SkinnableComponent;
		private var loadProgress:SkinnableComponent;	//下载进度
		private var playProgress:SkinnableComponent;	//播放进度
		
		public function ProgressBar() {
			buttonMode = true;
			background = new SkinnableComponent();
			background.skin = new Skin(new ProgressbarBgAsset());
			addChild(background);
			
			loadProgress = new SkinnableComponent();
			loadProgress.skin = new Skin(new ProgressbarLoadAsset());
			addChild(loadProgress);
			loadProgress.width = 0;
			
			playProgress = new SkinnableComponent();
			playProgress.skin = new Skin(new ProgressbarPlayAsset());
			addChild(playProgress);
			playProgress.width = 0;
			
			thumb = new Button();
			thumb.skin = new ButtonSkin(new ProgressbarThumbAsset());
			thumb.y = int( (playProgress.height - thumb.height) / 2 );
			addChild(thumb);
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
			background.addEventListener(MouseEvent.CLICK, 		onMouseClick);
			loadProgress.addEventListener(MouseEvent.CLICK, 	onMouseClick);
			playProgress.addEventListener(MouseEvent.CLICK, 	onMouseClick);
		}
	
		private function onThumbMouseDown(event:MouseEvent):void {
			isDraged = true;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			var bounds:Rectangle = new Rectangle(0, thumb.y, background.width - thumb.width, 0);
			thumb.startDrag(false, bounds);
		}
		
		private function onEnterFrame(event:Event):void {
			if(thumb.x + thumb.width >= width) {
				playProgress.width = width;	
			}else {
				playProgress.width = thumb.x + thumb.width / 2;	
			}
		}
		
		private function onStageMouseUp(event:MouseEvent):void {
			isDraged = false;
			thumb.stopDrag();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			playPercent = thumb.x / (background.width - thumb.width);
			dispatchEvent(new Event(ProgressBar.DRAG));
		}
		
		private function onMouseClick(event:MouseEvent):void {
			var point:Point = globalToLocal(new Point(event.stageX, event.stageY));
			var localX:Number = point.x - thumb.width / 2;
			if(localX < 0) {
				localX = 0;	
			}
			var maxX:Number = background.width - thumb.width;
			if(localX > maxX) {
				localX = maxX;	
			}
			playPercent = localX / maxX;
			Tweener.addTween(thumb,    {x:localX, time:0.2});
			Tweener.addTween(playProgress, {width:localX + thumb.width / 2, time:0.2});
			dispatchEvent(new Event(ProgressBar.CLICK));
		}
		
	
		public function updatePlayProgress(value:Number):void {
			if(!isDraged) {
				playPercent = value;
				thumb.x = (background.width - thumb.width) * value;
				if(thumb.x + thumb.width >= width) {
					playProgress.width = width;	
				}else {
					playProgress.width = thumb.x + thumb.width / 2;
				}	
			}
		}
		
		public function updateLoadProgress(value:Number):void {
			loadPercent = value;
			if(value <= 0) {
				loadProgress.width = 0;	
			}else if(value < 1) {
				loadProgress.width = (background.width - thumb.width) * value + thumb.width / 2;	
			}else {
				loadProgress.width = background.width;		
			}
		}
		
		override public function get height():Number {
			return background.height;
		}
		
		override public function set width(value:Number):void {
			var progress:Number = thumb.x / (background.width - thumb.width);  
			background.width = value;
			thumb.x = (background.width - thumb.width) * progress;
			if(thumb.x + thumb.width >= width) {
				playProgress.width = width;	
			}else {
				playProgress.width = thumb.x + thumb.width / 2;
			}
			if(loadPercent <= 0) {
				trace("1 lastLoadProgress: " + loadPercent);
				loadProgress.width = 0;	
			}else if(loadPercent < 1) {
				trace("2 lastLoadProgress: " + loadPercent);
				loadProgress.width = (background.width - thumb.width) * loadPercent + thumb.width / 2;	
			}else {
				trace("3 lastLoadProgress: " + loadPercent);
				loadProgress.width = background.width;		
			}
			if(ruler) {
				ruler.width = value;	
			}
		}
		
		//测试用，将来要删除
		private var ruler:Ruler;
	 
		public function createDebugRuler(totalTime:Number, times:Vector.<Number>):void {
			if(ruler && contains(ruler)){
				removeChild(ruler);	
			}
			ruler = new Ruler(totalTime, times);
			addChild(ruler);
			ruler.width = background.width;
		}
	}
}


import com.shen100.player.utils.PlayerUtil;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class Ruler extends Sprite {
	
	private var _times:Vector.<Number>;
	private var _totalTime:Number = 0;
	
	public function Ruler(totalTime:Number, times:Vector.<Number>):void {
		_totalTime = totalTime;
		_times = times;
		for (var i:int = 0; i < times.length - 1; i++) {
			var newline:Line = new Line();
			addChild(newline);
			newline.name = "line" + i;
			
			var txt:TextField = new TextField();
			var format:TextFormat = new TextFormat();
			format.color = 0xFF0000;
			
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = format;
			addChild(txt);
			txt.text = PlayerUtil.formatTime(times[i]);
			txt.name = "txt1" + i;
			txt.y = - txt.height;
			
			txt = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = format;
			addChild(txt);
			txt.text = times[i] + "";
			txt.name = "txt2" + i;
			txt.y = - 2 * txt.height;
		}
	}
	
	override public function set width(value:Number):void {
		var time:Number = 0;
		for (var i:int = 0; i < _times.length - 1; i++) {
			time += _times[i];
			var x:Number = time / _totalTime * value;
			
			var child:DisplayObject = getChildByName("line" + i);
			child.x = x;
			child = getChildByName("txt1" + i);
			child.x = x;
			child = getChildByName("txt2" + i);
			child.x = x;
		}
	}
}

class Line extends Shape {
	
	public function Line():void {
		this.graphics.lineStyle(1, 0xFF0000);
		this.graphics.lineTo(0, 6);
	}
}







