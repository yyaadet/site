package city.list
{
	import city.model.City;
	
	import utils.list.GameList;
	
	/**
	 * 城池列表 
	 * @author bxl
	 * 
	 */	
	public class CityList extends GameList
	{
		public function CityList()
		{
			super();
		}
		
		/**
		 * 根据名称获取城池 
		 * @param cityName
		 * @return 
		 * 
		 */		
		public function getCityByName(cityName:String):City
		{
			var i:int = 0;
			var len:int = 0;
			var gameCity:City = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameCity = getObjByIndex(i) as City;
				if (gameCity != null && gameCity.cityName == cityName)
					return gameCity;
			}
			
			return null;
		}
		
		/**
		 * 获取可分配坞堡的城池列表 
		 * @return 
		 * 
		 */		
		public function getAllotedCityList():CityList
		{
			var i:int = 0;
			var len:int = 0;
			var gameCity:City = null;
			var ret:CityList = new CityList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameCity = getObjByIndex(i) as City;
				if (gameCity != null && gameCity.isAlloted && gameCity.wubaoNum > 0)
					ret.add(gameCity);
			}
			
			return ret;
		}
		
	}
}