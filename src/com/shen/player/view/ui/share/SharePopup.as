package com.shen.player.view.ui.share {
	
	import com.shen.player.config.ApplicationConfig;
	import com.shen.uicomps.components.Button;
	import com.shen.uicomps.components.Label;
	import com.shen.uicomps.components.RadioButton;
	import com.shen.uicomps.components.SkinnableComponent;
	import com.shen.uicomps.components.skin.ButtonSkin;
	import com.shen.uicomps.components.skin.RadioButtonSkin;
	import com.shen.uicomps.components.skin.Skin;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SharePopup extends Sprite {
		
		private var left:Number = 20;
		private var right:Number = 20;
		private var gap:Number = 14;
		private var snsGap:Number = 12;
		
		private var background:SkinnableComponent;
		private var title:Label;
		public var closeButton:Button;
		private var shareTip:Label;
		private var copyTip:Label;
		private var htmlCode:String = '<embed src="{playerUrl}" quality="high" width="480" height="400" ' 
										+ 'align="middle" allowScriptAccess="always" flashvars="vid={vid}" ' 
										+ 'allowFullscreen="true" type="application/x-shockwave-flash"></embed>';
		private var htmlCodeText:TextField;
		private var flashText:TextField;
		
		public var sinaWeibo:Button;
		public var qqWeibo:Button;
		public var douban:Button;
		public var qqPengyou:Button;
		public var kaixin:Button;
		public var tianya:Button;
		public var renren:Button;
		public var qZone:Button;
	
		private var htmlRadioButton:RadioButton;
		private var flashRadioButton:RadioButton;
		
		public function SharePopup() {
			background = new SkinnableComponent();
			background.skin = new Skin(new SharePopupBgAsset());
			addChild(background);
			
			title = new Label();
			title.text = "分享";
			title.fontFamily = "Microsoft YaHei";
			title.textColor = 0xFFFFFF;
			title.textSize = 14;
			addChild(title);
			title.x = 5;
			title.y = 5;
			
			closeButton = new Button();
			closeButton.skin = new ButtonSkin(new CloseButtonAsset());
			addChild(closeButton);
			closeButton.x = background.width - closeButton.width  - 8;
			closeButton.y = 8;
			
			shareTip = new Label();
			shareTip.text = "一键分享到：";
			shareTip.textColor = 0xFFFFFF;
			shareTip.textSize = 14;
			addChild(shareTip);
			shareTip.x = left;
			shareTip.y = title.y + title.height + gap;
			
			createSNSButtons();
			
			copyTip = new Label();
			copyTip.text = "复制转帖：";
			copyTip.textColor = 0xFFFFFF;
			copyTip.textSize = 14;
			addChild(copyTip);
			copyTip.x = left;
			copyTip.y = sinaWeibo.y + sinaWeibo.height + gap;
			
			htmlCodeText = new TextField();
			addChild(htmlCodeText);
			htmlCodeText.textColor = 0xCCCCCC;
			htmlCodeText.border = true;
			htmlCodeText.borderColor = 0x999999;
			htmlCodeText.width = 218;
			htmlCodeText.height = 24;
			htmlCodeText.x = left;
			htmlCodeText.y = copyTip.y + copyTip.height + gap;
			
			flashText = new TextField();
			addChild(flashText);
			flashText.textColor = 0xCCCCCC;
			flashText.border = true;
			flashText.borderColor = 0x999999;
			flashText.width = 218;
			flashText.height = 24;
			flashText.x = left;
			flashText.y = htmlCodeText.y + htmlCodeText.height + 8;
			
			htmlRadioButton = new RadioButton("shareRadioButtonGroup", false, onRadioButtonClick);
			htmlRadioButton.skin = new RadioButtonSkin(new HtmlRateRadioButtonAsset());
			addChild(htmlRadioButton);
			htmlRadioButton.x = background.width - htmlRadioButton.width - right;
			htmlRadioButton.y = htmlCodeText.y;
			
			flashRadioButton = new RadioButton("shareRadioButtonGroup", false, onRadioButtonClick);
			flashRadioButton.skin = new RadioButtonSkin(new FlashRadioButtonAsset());
			addChild(flashRadioButton);
			flashRadioButton.x = background.width - flashRadioButton.width - right;
			flashRadioButton.y = flashText.y;
		}
		
		private function onRadioButtonClick(event:MouseEvent):void {
			if(event.currentTarget == htmlRadioButton) {
				flashText.alwaysShowSelection = false;
				htmlCodeText.alwaysShowSelection = true;
				htmlCodeText.setSelection(0, htmlCodeText.length);
				System.setClipboard(htmlCodeText.text);
			}else {
				htmlCodeText.alwaysShowSelection = false;
				flashText.alwaysShowSelection = true;
				flashText.setSelection(0, flashText.length);
				System.setClipboard(flashText.text);	
			}
		}
		
		private function createSNSButtons():void {
			sinaWeibo = new Button();
			sinaWeibo.skin = new ButtonSkin(new ShareSinaButtonAsset());
			addChild(sinaWeibo);
			sinaWeibo.x = left;
			sinaWeibo.y = shareTip.y + shareTip.height + gap;
			
			qqWeibo = new Button();
			qqWeibo.skin = new ButtonSkin(new ShareQQWeiboButtonAsset());
			addChild(qqWeibo);
			qqWeibo.x = sinaWeibo.x + sinaWeibo.width + snsGap;
			qqWeibo.y = sinaWeibo.y;
			
			qqPengyou = new Button();
			qqPengyou.skin = new ButtonSkin(new ShareQQPengyouButtonAsset());
			addChild(qqPengyou);
			qqPengyou.x = qqWeibo.x + qqWeibo.width + snsGap;
			qqPengyou.y = sinaWeibo.y;
			
			renren = new Button();
			renren.skin = new ButtonSkin(new ShareRenrenButtonAsset());
			addChild(renren);
			renren.x = qqPengyou.x + qqPengyou.width + snsGap;
			renren.y = sinaWeibo.y;
			
			douban = new Button();
			douban.skin = new ButtonSkin(new ShareDoubanButtonAsset());
			addChild(douban);
			douban.x = renren.x + renren.width + snsGap;
			douban.y = sinaWeibo.y;
			
			qZone = new Button();
			qZone.skin = new ButtonSkin(new ShareQzoneButtonAsset());
			addChild(qZone);
			qZone.x = douban.x + douban.width + snsGap;
			qZone.y = sinaWeibo.y;
			
			kaixin = new Button();
			kaixin.skin = new ButtonSkin(new ShareKaixinButtonAsset());
			addChild(kaixin);
			kaixin.x = qZone.x + qZone.width + snsGap;
			kaixin.y = sinaWeibo.y;
			
			tianya = new Button();
			tianya.skin = new ButtonSkin(new ShareTianyaButtonAsset());
			addChild(tianya);
			tianya.x = kaixin.x + kaixin.width + snsGap;
			tianya.y = sinaWeibo.y;
		}
		
		public function set data(data:Object):void {
			var theHtmlCode:String = htmlCode.replace("{playerUrl}", data.url);
			theHtmlCode = theHtmlCode.replace("{vid}", data.vid);
			htmlCodeText.text = theHtmlCode;
			flashText.text = data.url + "?vid=" + data.vid;
		}
		
	}
}













