package map.list
{
	import map.model.MapCity;
	
	import utils.GameManager;
	import utils.list.GameList;

	public class MapCityList extends GameList
	{
		public function MapCityList()
		{
			super();
		}
		
		/**
		 * 设置城池状态
		 * 设置本方势力城池为可入城，不可攻击状态
		 * 设置非本方势力城池为可攻击，不可入城状态 
		 * 
		 */		
		public function setAllCityState():void
		{
			var selfID:int = 0;
			selfID = GameManager.gameMgr.wubao.sphereID;
			if (selfID <= 0) return;
			
			var i:int = 0;
			var len:int = 0;
			var mapCity:MapCity = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				mapCity = getObjByIndex(i) as MapCity;
				
				if (GameManager.gameMgr.dipList.isEne(selfID, mapCity.gameCity.sphereID))
				{
					mapCity.isAttack = true;
					mapCity.isEnterCity = false;
				}
				else
				{
					mapCity.isAttack = false;
					mapCity.isEnterCity = true;
				}
			} 
			
		}
		
		/**
		 * 设置所有城池为不可入城，不可攻击状态 
		 * 
		 */		
		public function setAllCityNone():void
		{
			var i:int = 0;
			var len:int = 0;
			var mapCity:MapCity = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				mapCity = getObjByIndex(i) as MapCity;
				
				mapCity.isAttack = false;
				mapCity.isEnterCity = true;
			} 
		}
		
	}
}