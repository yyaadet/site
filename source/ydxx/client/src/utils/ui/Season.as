package utils.ui
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	import images.AssetsManager;
	
	import mx.containers.Canvas;
	
	import utils.GameManager;
	
	/**
	 * 季节显示类 
	 * @author StarX
	 * 
	 */	
	public class Season extends Canvas
	{
		//游戏当前月份
		private var _month:int = 0;
		
		private var timer:Timer = new Timer(500); 
		private var flag:Boolean = false;
		
		public function Season()
		{
			super();
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(evt:MouseEvent):void
		{
			this.toolTip = GameManager.gameMgr.gameYear.toString() + "年" + GameManager.gameMgr.gameMonth.toString() + "月" + 
			               GameManager.gameMgr.gameDay.toString() + "日" + GameManager.gameMgr.gameHour.toString() + "时";
		}
		
		public function showSeason():void
		{
			_month = GameManager.gameMgr.gameMonth;
			if (_month == 0) return;
			
			if (_month >= 2 && _month <= 4)
			{
				drawSeason(1);
			}
			else if (_month >= 5 && _month <= 7)
			{
				drawSeason(2);
			}
			else if (_month >= 8 && _month <= 10)
			{
				drawSeason(3);
			}
			else
			{
				drawSeason(4);
			}
		}
		
		public function startFlash():void
		{
			if (timer.running) return;
			timer.start();
		}
		
		public function stopFlash():void
		{
			timer.stop();
			this.alpha = 1;
		}
		
		private function onTimer(evt:TimerEvent):void
		{
			flag = !flag;
			this.alpha = flag?0.4:1;
		}
		
		private function drawSeason(type:int):void
		{
			var image:Bitmap;
			if (type == 1)
			{
				var Spring:Class = AssetsManager.assetsMgr.MAP_SPRING;
				image = new Spring();
			}
			else if (type == 2)
			{
				var Summer:Class = AssetsManager.assetsMgr.MAP_SUMMER;
				image = new Summer();
			}
			else if (type == 3)
			{
				var Autumn:Class = AssetsManager.assetsMgr.MAP_AUTUMN;
				image = new Autumn();
			}
			else if (type == 4)
			{
				var Winter:Class = AssetsManager.assetsMgr.MAP_WINTER;
				image = new Winter();
			}
			
			this.width = image.width;
			this.height = image.width;
			
			this.graphics.clear();	
			this.graphics.beginBitmapFill(image.bitmapData, new Matrix(), false);
			this.graphics.drawRect(0, 0, image.width, image.width);
			this.graphics.endFill();	
		}
		
		public function get month():int
		{
			return _month;
		}
		
		public function set month(param:int):void
		{
			_month = param;
		}
		
	}
}