package com.shen100.player.model.vo {
	
	public class VideoVO {
		
		public var vid:String;					//视频id
		public var commvId:String;
		public var isHD:Boolean;				//是否高清
		public var userId:String;				//视频上传者id
		public var title:String;				//视频标题
		public var picPath:String;				//视频预览小图
		public var bigPicPath:String;			//视频预览大图
		public var cid:String;					//视频所属频道id
		public var pid:String;					//页面标识
		public var tags:String;					//视频标签
		public var payurl:String;				//付费信息
		public var licence:String;				//国审编号
		public var mediasrc:int;				//视频上传来源
		public var totalTime:Number;			//视频总时长
		public var times:Vector.<Number>;		//分段视频时长
		public var byteTotal:Number;			//视频大小
		public var bitrate:int;					//默认码率(kb/s)
		public var gslbUrls:Vector.<String>;	//视频有多个分段的话，就是多个分段的url
		public var count:int;					//视频分段数
		public var bitrates:Vector.<BitrateVO>;	//视频码率信息
		
		public function VideoVO() {
			
		}
		
		public function set data(data:Object):void {
			vid			= data.vid;
			commvId 	= data.commvid;
			isHD 		= data.hd == 1 ? true : false;
			userId		= data.u;
			title		= data.t;
			picPath		= data.picpath;
			bigPicPath  = data.bigpicpath ? data.bigpicpath : data.picpath;
			cid			= data.c;
			pid			= data.pid;
			tags  		= data.tag;
			payurl		= data.payurl;
			licence 	= data.movie_licence;
			mediasrc	= data.mediasrc;
			//视频时长(单位毫秒)，"总时长，第一个分段视频时长，第二个分段视频时长..." 
			var vtimes:String = data.vtimems;         
			var vtimeArr:Array = vtimes.split(",");
			if(vtimeArr.length > 1) {
				vtimeArr.splice(0, 1);
			} 
			totalTime = 0;
			times = new Vector.<Number>();
			for each (var time:Number in vtimeArr) {
				time = int(time / 1000);
				times.push(time);
				totalTime += time;
			}
			var vsize:String = data.videosize;
			if(vsize.indexOf("@") != -1) {//视频大小与码率，如果里面包含＠，＠前面表示码率信息
				var sizeAndRate:Array = vsize.split("@");
				bitrate = sizeAndRate[0];
				byteTotal = sizeAndRate[1];
			}else {
				byteTotal = Number(vsize);	
				bitrate = byteTotal / totalTime / 1024 * 8;	//码率单位kb/s
			}
			var videoUrlArr:Array = data.f.split(",");
			gslbUrls = new Vector.<String>();
			for each (var url:String in videoUrlArr) {
				gslbUrls.push(url);	
			}
			count = gslbUrls.length;
		}
		
		//请求视频信息和请求推荐视频两个接口返回的数据结构不一样
		//所以用了两个方法，data和hotData
		public function set hotData(data:Object):void {
			vid 	= data.vid;
			title 	= data.title;
		}
		
		public function set bitrateData(data:Object):void {
			var bitratesArr:Array = (data.RateInfo as String).split(";");
			bitrates = new Vector.<BitrateVO>();
			//bitratesArr[0]是旧版播放器当前视频码率, 从1往后是所有的视频码率
			for (var i:int = 1; i < bitratesArr.length; i++) {
				var bitrate:Array = bitratesArr[i].split("@");	
				bitrates.push(new BitrateVO(bitrate[0], bitrate[1]));	
			}
		}
		
	}
}













