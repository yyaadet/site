package map
{
	import flash.geom.Point;
	
	
	/**
	 * 地图模块公共库 
	 * @author StarX
	 * 
	 */	
	public class MapUtil
	{
		//整个背景地图分割成40*40
		public static const mapRow:int = 10;
		public static const mapCol:int = 10;
		
		//地图背景分割成10*10的小格子
		public static const mapGridW:int = 10;
		public static const mapGridH:int = 10;
		
		//地图切片的宽高
		public static const sliceWidth:int = 500;
		public static const sliceHeight:int = 400;
		
		//地图图片的后缀名
		public static const mapSuffix:String = ".jpg";
		
		public function MapUtil()
		{
			
		}
		
		/**
		 * 获取地图图片文件的名字， 返回格式 0101 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function mapValue(value:int):String
		{
			var ret:String = "";
			
			if (value.toString().length < 2)
				ret = "0" + value.toString();
			else 
				ret = value.toString();
			
			return ret;	
		}
		
		/**
		 * 服务器的地图坐标与客户端的地图坐标之间的互换
		 * @param mapX
		 * @param mapY
		 * @return 
		 * 
		 */		
		public static function transCoor(mapX:int, mapY:int):Point
		{
		   var ret:Point = new Point();
		
		   ret.x = mapX;
		   ret.y = mapCol * sliceHeight / mapGridH - mapY - 1;
		
		   return ret;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
		
	}
}