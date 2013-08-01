package {
	
	import caurina.transitions.Tweener;
	
	import com.shen.player.PlayerFacade;
	import com.shen.player.model.constant.PlayerState;
	import com.shen.player.view.ui.control.ControlBar;
	import com.shen.player.view.ui.control.ProgressBar;
	import com.shen.player.view.ui.side.SideBar;
	import com.shen.player.view.ui.video.VideoBox;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	[SWF(width="610", height="500", backgroundColor="#999999", frameRate="30")]
	//[SWF(width="930", height="500", frameRate="30")]
	public class Player extends Sprite {
		
		private static const APP_FACADE_NAME:String = "Player_Runtime_" + getTimer();
		
		private var facade:PlayerFacade = PlayerFacade.getInstance( APP_FACADE_NAME );
		
		private var _playerWidth:Number 	= 0;  //播放器的宽度
		private var _playerHeight:Number 	= 0;  //播放器的高度
		
		public var data:Object;  //外部传来的数据，来自页面或父swf
		
		public var playerState:String;	//播放器当前的状态
		
		public var videoBox:VideoBox;  			//视频容器
		public var progressBar:ProgressBar;  	//进度条
		public var controlBar:ControlBar;  		//控制条
		public var sideBar:SideBar;				//侧边工具条
		
		public var play:Function;    		//播放器提供给外部的接口, 调此方法播放视频
		public var pause:Function;   		//播放器提供给外部的接口, 调此方法暂停视频
		public var resume:Function;  		//播放器提供给外部的接口, 调此方法继续播放视频
		public var setPlayerSize:Function; 	//播放器提供给外部的接口, 调此方法来设置播放器大小
		
		public function Player() {
			videoBox = new VideoBox();
			addChild(videoBox);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			var params:Object = {};
			if(parent == stage) {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.addEventListener(Event.RESIZE, onResize);
				params.width = stage.stageWidth;
				params.height = stage.stageHeight;
			}
			var flashVars:Object = loaderInfo.parameters;
			for (var key:String in flashVars) {
				params[key] = flashVars[key];	
			}
			data = params;
			data.width  = data.width  ? data.width  : 0;
			data.height = data.height ? data.height : 0;
			setSize(data.width, data.height);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			facade.startup(this);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if( (playerState == PlayerState.PLAYING || playerState == PlayerState.PAUSE) 
				&& sideBar && contains(sideBar)) {
				if(mouseX >= _playerWidth / 2) {
					Tweener.addTween(sideBar, {x:_playerWidth - sideBar.width, time:0.5});	
				}else {
					Tweener.addTween(sideBar, {x:_playerWidth, time:0.5});	
				}
			}
		}
		
		private function onRollOut(event:MouseEvent):void {
			if( (playerState == PlayerState.PLAYING || playerState == PlayerState.PAUSE) 
				  && sideBar && contains(sideBar)) {
				Tweener.addTween(sideBar, {x:_playerWidth, time:0.5});
			}	
		}
		
		private function onResize(event:Event):void {
			setSize(stage.stageWidth, stage.stageHeight);
		}
		
		//设置播放器大小
		public function setSize(width:Number, height:Number):void {
			_playerWidth = width;
			_playerHeight = height;	
			var videoBoxHeight:Number = height;
			//progressBar, controlBar, sideBar根据外部传的参数
			//来决定是否创建, 所以要判断它们是否存在
			//以下代码还能够精简些，不过，这样好理解些，所以保持这样就好
			if(progressBar) {
				videoBoxHeight -= progressBar.height;
				if(videoBoxHeight <= 0) {
					videoBoxHeight += progressBar.height;	
					progressBar.visible = false;
				}else {
					progressBar.visible = true;
				}
			}
			if(controlBar) {
				videoBoxHeight -= controlBar.height;
				if(videoBoxHeight <= 0) {
					videoBoxHeight += controlBar.height;
					controlBar.visible = false;
				}else {
					controlBar.visible = true;	
				}
			}
			videoBox.setSize(width, videoBoxHeight);
			if(progressBar) {
				progressBar.width = width;
				progressBar.y = videoBoxHeight;	
			}
			if(controlBar) {
				controlBar.width = width;
				if(progressBar) {
					controlBar.y = progressBar.y + progressBar.height;	
				}else {
					controlBar.y = videoBoxHeight;
				}
			}
			if(sideBar) {
				if(videoBoxHeight <= sideBar.height) {
					if(contains(sideBar)) {
						removeChild(sideBar);	
					}
				}else {
					addChild(sideBar);
					sideBar.x = width;
					sideBar.y = (videoBoxHeight - sideBar.height) / 2;
				}
			}
		}
		
		public function get playerWidth():Number {
			return _playerWidth;
		}
		
		public function get playerHeight():Number {
			return _playerHeight;
		}
	}
}



