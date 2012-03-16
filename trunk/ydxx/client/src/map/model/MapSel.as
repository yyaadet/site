package map.model
{
	import map.MapUtil;
	
	import mx.core.UIComponent;
	
	/**
	 * 小地图选择框 
	 * @author StarX
	 * 
	 */	
	public class MapSel extends UIComponent
	{
		public function MapSel(rateW:Number, rateH:Number, mapWidth:Number)
		{
			super();
			
			var w:Number = 0;
			var h:Number = 0;
			
			w = mapWidth * rateW / (MapUtil.sliceWidth * MapUtil.mapRow);
			h = w * rateH / rateW;
			this.width = w + 2;
			this.height = h + 2;
			
			drawBG();
			this.mouseEnabled = false;
		}
		
		private function drawBG():void
		{
			var w:int = 0;
			var h:int = 0;
			
			w = Math.ceil(this.width);
			h = Math.ceil(this.height);
			
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, w, 1);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(w - 1, 0, 1, h);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, h - 1, w, 1);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, 1, h);
			this.graphics.endFill();
			
			this.graphics.beginFill(0xFFFFFF, 0.3);
			this.graphics.drawRect(1, 1, w - 2, h - 2);
			this.graphics.endFill();
		}
		
	}
}