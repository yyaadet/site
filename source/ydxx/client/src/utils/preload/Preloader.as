package utils.preload
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	
	/**
	 * 预加载类 
	 * @author StarX
	 * 
	 */	
	public class Preloader extends DownloadProgressBar
	{
		[Embed(source="../../images/assets/preload/bg.jpg", mimeType="application/octet-stream")]
		private var BG:Class;
		
		[Embed(source="../../images/assets/preload/horse.swf", mimeType="application/octet-stream")]
		private var HORSE:Class;
		
		private var progressText:TextField;
		
		private var horse:Loader = null;
		
		public function Preloader()
		{
			super();
			
			//背景
			var bg:Loader = new Loader();
			bg.loadBytes(new BG() as ByteArray);
			this.addChild(bg);
			
			//马
			horse = new Loader();
			horse.loadBytes(new HORSE() as ByteArray);
			horse.contentLoaderInfo.addEventListener(Event.COMPLETE, horseLoadComplete);
			this.addChild(horse);
			horse.x = 300;
			horse.y = 270;
			
			//进度文字
			progressText = new TextField();
			progressText.width = 100;
			progressText.height = 20;
			progressText.x = (1000 - 100) / 2 ;
			progressText.y = 320;
			this.addChild(progressText);
		}
		
		private function horseLoadComplete(evt:Event):void
		{
			horse.width = horse.width * 0.5;
			horse.height = horse.height * 0.5;
		}
		
		/**
		 * 重写这个函数，来实现自己Preloader的设置，而不是用其默认的设置 
		 * @param value
		 * 
		 */		
		override public function set preloader(value:Sprite):void
		{
			value.addEventListener(ProgressEvent.PROGRESS, progHandler);
			value.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteHandler);
			
			//设置预加载界面的位置
			x = (stageWidth - 1000) * 0.5;
			y = (stageHeight - 620) * 0.5;
		}
		
		private function progHandler(e:ProgressEvent):void
		{
			var progPer:Number = 0;
			var progWidth:Number = 0;
			
			progPer = e.bytesLoaded / e.bytesTotal * 100;
			progWidth = e.bytesLoaded / e.bytesTotal * 340;
			horse.x = progWidth + 300;
			progressText.text = "已下载 " + int(progPer).toString() + "%";
		}
		
		private function initCompleteHandler(e:FlexEvent):void
		{
			//派发加载完成事件，通知外部可以进入主程序了
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}