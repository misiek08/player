package com.shen100.player.view.ui.video {
	
	import com.shen100.core.geom.Size;
	import com.shen100.core.util.Util;
	import com.shen100.player.model.constant.VideoScaleMode;
	import com.shen100.uicomps.components.Image;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetStream;
	
	public class VideoBox extends Sprite {
	
		private var bgColor:uint = 0x000000;
		private var bg:Shape;
		private var img:Image;
		private var _video:Video;
		private var _stageVideo:*;
		private var _videoMetaData:Object;
		private var _videoScaleMode:String;
		private var netStream:NetStream;
		private var bufferBox:BufferBox;
		
		public function VideoBox() {
			bg = new Shape();
			addChild(bg);
			_video = new Video();
			_video.smoothing = true;
			addChild(_video);
			img = new Image();
			addChild(img);
		}
		
		public function set imageUrl(url:String):void {
			if(img) {
				img.addEventListener(Image.LOAD_RESULT, onImageLoaded);
				img.smoothing = true;
				img.source = url;	
			}
		}
		
		private function onImageLoaded(event:Event):void {
			img.removeEventListener(Image.LOAD_RESULT, onImageLoaded);
			scaleImage(width, height);
		}
		
		public function removeImage():void {
			if(img && contains(img)) {
				img.clear();
				removeChild(img);
				img.removeEventListener(Image.LOAD_RESULT, onImageLoaded);
				img = null;
			}
		}
		
		public function set videoStream(value:NetStream):void {
			netStream = value;
			if(_stageVideo) {
				_stageVideo.attachNetStream(value);	
			}else {
				_video.attachNetStream(value);	
			}
		}
		
		public function set videoMetaData(value:Object):void {
			_videoMetaData = value;
			scaleVideo(width, height);
		}
		
		public function set stageVideo(value:*):void {
			_stageVideo = value;
			if(_stageVideo) {
				_stageVideo.attachNetStream(netStream);
				bg.visible = false;
				if(contains(_video)) {
					removeChild(_video);	
				}
			}else {
				_video.attachNetStream(netStream);
				var index:int = getChildIndex(bg);
				addChildAt(_video, index + 1);
				bg.visible = true;
			}
			scaleVideo(width, height);
		}
		
		public function set videoScaleMode(value:String):void {
			_videoScaleMode = value;
			scaleVideo(width, height);
		}

		private function scaleVideo(width:Number, height:Number):void {
			var x:Number;
			var y:Number;
			var size:Size;
			if(_videoMetaData) {
				switch(_videoScaleMode) {
					case VideoScaleMode.FIT:{
						size = Util.scaleToMax(_videoMetaData.width, _videoMetaData.height, width, height);
						x = (width - size.width) / 2;
						y = (height - size.height) / 2;
						break;
					}
					case VideoScaleMode.FILL:{
						x = y = 0;
						size = new Size(width, height);
						break;	
					}
					case VideoScaleMode.CLIP:{
						size = Util.scaleToClip(_videoMetaData.width, _videoMetaData.height, width, height);
						x = (width - size.width) / 2;
						y = (height - size.height) / 2;
						break;
					}
				}
				if(_stageVideo) {
					_stageVideo.viewPort = new Rectangle(x, y, size.width, size.height);
				}else {
					_video.width = size.width;
					_video.height = size.height;
					_video.x = x;
					_video.y = y;
				}
			}else {
				if(_stageVideo) {
					_stageVideo.viewPort = new Rectangle(0, 0, width, height);	
				}else {    
					_video.width = width;
					_video.height = height;
					_video.x = 0;
					_video.y = 0;
				}	
			}
		}
		
		private function scaleImage(width:Number, height:Number):void {
			if(img) {
				var size:Size = Util.scaleToMax(img.originalWidth, img.originalHeight, width, height);
				img.width = size.width;
				img.height = size.height;
				img.x = (width - img.width) / 2;
				img.y = (height - img.height) / 2;		
			}
		}
		
		private function drawBackground(width:Number, height:Number):void {
			bg.graphics.clear();
			bg.graphics.beginFill(bgColor);
			bg.graphics.drawRect(0, 0, width, height);
			bg.graphics.endFill();	
		}
		
		public function get video():Video {
			return _video;
		}
		override public function get width():Number {
			return bg.width;
		}
		
		override public function get height():Number {
			return bg.height;
		}
		
		public function set bufferPercent(value:int):void {
			if(!bufferBox) {
				bufferBox = new BufferBox();
				bufferBox.x = bg.width / 2;
				bufferBox.y = bg.height / 2;
			}
			addChild(bufferBox);
			bufferBox.bufferPercent = value;
		}
		
		public function removeBuffer():void {
			if(bufferBox) {
				if(contains(bufferBox)) {
					removeChild(bufferBox);	
				}
				bufferBox = null;
			}
		}
		
		public function setSize(width:Number, height:Number):void {
			drawBackground(width, height);
			scaleVideo(width, height);
			scaleImage(width, height);
			if(bufferBox) {
				bufferBox.x = bg.width / 2;
				bufferBox.y = bg.height / 2;	
			}
		}
		
	}
}















