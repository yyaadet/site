package map.model
{
	import city.model.City;
	
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	
	import images.AssetsManager;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import utils.PubUnit;

	public class MapFlag extends UIComponent
	{
		private var _gameCity:City = null;
		
		private var lblName:Label = null;
		
		public function MapFlag()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			var flagClass:Class = AssetsManager.assetsMgr.MAP_FLAG;
			var bmp:Bitmap = new flagClass();
			this.graphics.beginBitmapFill(bmp.bitmapData, new Matrix(), false);
			this.graphics.drawRect(0, 0, bmp.width, bmp.height);
			this.graphics.endFill();
			
			this.width = bmp.width;
			this.height = bmp.height;
			
			if (lblName == null)
			{
				lblName = new Label();
				lblName.x = 9;
				lblName.y = 9;
				lblName.width = 15;
				lblName.height = 16;
				lblName.setStyle("color", PubUnit.WHITE);
				lblName.setStyle("fontSize", 12);
				lblName.setStyle("fontFamily", "新宋体");
				lblName.text = "";
				this.addChild(lblName);
			}
		}
		
		public function get gameCity():City
		{
			return _gameCity;
		}
		
		public function set gameCity(param:City):void
		{
			_gameCity = param;
			
			if (lblName != null)
				lblName.text = _gameCity.sphereName.substr(0, 1);
		}
		
	}
}