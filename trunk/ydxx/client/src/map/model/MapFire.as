package map.model
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import images.AssetsManager;
	
	import mx.containers.Canvas;
	
	/**
	 * 战斗时的火焰效果 
	 * @author bxl
	 * 
	 */	
	public class MapFire extends Canvas
	{
		private var _fireWidth:int = 0;
		
		private var _fireHeight:int = 0;
		
		private var timer1:Timer = null;
		private var fireIndex:int = 1;
		
		//火焰最大次数
		private var fireMax:int = 10;
		private var fireCount:int = 0;
		
		public function MapFire()
		{
			super();
			
			if (timer1 == null)
			{
				timer1 = new Timer(200);
				timer1.addEventListener(TimerEvent.TIMER, onTimer);
			}
			
		}
		
		public function startFire():void
		{
			this.width = fireWidth;
			this.height = fireHeight;
			
			if (timer1.running)
			{
				timer1.stop();
				fireIndex = 1;
				fireCount = 0;
			}
				
			timer1.start();
		}
		
		public function stopFire():void
		{
			timer1.stop();
		}
		
		public function onTimer(evt:TimerEvent):void
		{
			this.setStyle("backgroundSize", "100%");
			
			fireIndex ++;
			
			if (fireIndex == 4)
				fireIndex = 1;
		}
		
		public function remove():void
		{
			timer1.stop();
			timer1.removeEventListener(TimerEvent.TIMER, onTimer);
			timer1 = null;
			
			this.clearStyle("backgroundSize");
		}
		
		//=======================================================================
		// 属性
		//=======================================================================
		
		public function get fireWidth():int
		{
			return _fireWidth;
		}
		
		public function set fireWidth(param:int):void
		{
			_fireWidth = param;
		}
		
		public function get fireHeight():int
		{
			return _fireHeight;
		}
		
		public function set fireHeight(param:int):void
		{
			_fireHeight = param;
		}
		
	}
}