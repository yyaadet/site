package map.model
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	/**
	 * 地图圆点
	 * @author StarX
	 * 
	 */	
	public class MapPoint extends UIComponent
	{
		//圆点属于的军团ID
		private var _armyID:int = 0;
		
		//圆点的颜色
		private var _pColor:int = 0;
		
		//圆点的半径
		private var _pRadius:int = 0;
		
		public function MapPoint()
		{
			super();
		}
		
		public function draw():void
		{
			this.width = pRadius;
			this.height = pRadius;
			
			this.graphics.clear();
			this.graphics.beginFill(pColor);
			this.graphics.drawCircle(0, 0, pRadius);
			this.graphics.endFill();
		}
		
		/**
		 * 清空 
		 * 
		 */		
		public function clear():void
		{
			this.graphics.clear();
		}
		
		//=============================================================
		//属性
		//=============================================================
		
		public function get armyID():int
		{
			return _armyID;
		}
		
		public function set armyID(param:int):void
		{
			_armyID = param;
		}
		
		public function get pColor():int
		{
			return _pColor;
		}
		
		public function set pColor(param:int):void
		{
			_pColor = param;
		}
		
		public function get pRadius():int
		{
			return _pRadius;
		}
		
		public function set pRadius(param:int):void
		{
			_pRadius = param;
		}
		
	}
}