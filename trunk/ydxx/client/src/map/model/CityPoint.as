package map.model
{
	import city.model.City;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	import utils.PubUnit;
	
	/**
	 * 小地图上的城池点 
	 * @author bxl
	 * 
	 */	
	public class CityPoint extends UIComponent
	{
		private var _uniqID:int = 0;
		
		//城池对象
		private var _gameCity:City = null;
		
		//宽
		private var _pWidth:int = 0;
		
		//高
		private var _pHeight:int = 0;
		
		//点的填充颜色
		private var _pColor:uint = 0;
		
		//闪动是否结束
		private var isFlashEnd:Boolean = true;
		
		private var timer1:Timer = null;
		private var isFill:Boolean = false;
		
		//最大闪动次数
		private var flashMax:int = 10;
		private var flashCount:int = 0;
		
		public function CityPoint()
		{
			super();
			
			if (timer1 == null)
			{
				timer1 = new Timer(500);
				timer1.addEventListener(TimerEvent.TIMER, onTimer);
			}
		}
		
		public function draw():void
		{
			this.width = pWidth;
			this.height = pHeight;
			
			this.graphics.clear();
			this.graphics.beginFill(pColor);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		public function draw1(pColor1:uint, pColor2:uint):void
		{
			this.width = pWidth;
			this.height = pHeight;
			
			var per:Number = gameCity.wubaoNum / gameCity.wubaoTotal;
			var perW:int = this.width * per;
			
			this.graphics.clear();
			this.graphics.beginFill(pColor1);
			this.graphics.drawRect(0, 0, perW, height);
			this.graphics.endFill();
			
			var perW1:int = this.width - perW;
			this.graphics.beginFill(pColor2);
			this.graphics.drawRect(perW, 0, perW1, height);
			this.graphics.endFill();
		}
		
		public function setToolTip():void
		{
			var tip:String = "";
			
			tip = "城池 " + gameCity.cityName + "\n";
			
			if (gameCity.sphereID >= 1)
				tip += "势力 " + gameCity.sphereName;
			
			this.toolTip = tip;
		}
		
		public function startFlash(isEnd:Boolean = true):void
		{
			if (timer1.running)
			{
				if (isEnd)
					stopFlash();
				else
					return;
			}
			
			flashCount = 0;
			isFlashEnd = isEnd;
			timer1.start();
		}
		
		public function stopFlash():void
		{
			timer1.stop();
			draw();
		}
		
		private function onTimer(evt:TimerEvent):void
		{
			if (isFill)
			{
				this.graphics.clear();
				isFill = false;
			}
			else
			{
				draw();
				isFill = true;
			}
			
			flashCount ++;
			if (flashCount >= flashMax && isFlashEnd)
				stopFlash();
		}
		
		public function remove():void
		{
			timer1.stop();
			timer1.removeEventListener(TimerEvent.TIMER, onTimer);
			timer1 = null;
			
			this.graphics.clear();
		}
		
		//=============================================================
		//属性
		//=============================================================
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}
		
		public function get gameCity():City
		{
			return _gameCity;
		}
		
		public function set gameCity(param:City):void
		{
			_gameCity = param;
		}
		
		public function get pWidth():int
		{
			return _pWidth;
		}
		
		public function set pWidth(param:int):void
		{
			_pWidth = param;
		}
		
		public function get pHeight():int
		{
			return _pHeight;
		}
		
		public function set pHeight(param:int):void
		{
			_pHeight = param;
		}
		
		public function get pColor():int
		{
			return _pColor;
		}
		
		public function set pColor(param:int):void
		{
			_pColor = param;
		}
		
	}
}