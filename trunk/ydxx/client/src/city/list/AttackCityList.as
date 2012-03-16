package city.list
{
	import city.model.AttackCity;
	
	import utils.GameManager;
	import utils.list.GameList;

	/**
	 * 攻打城池战场列表 
	 * @author bxl
	 * 
	 */	
	public class AttackCityList extends GameList
	{
		public function AttackCityList()
		{
			super();
		}
		
		/**
		 * 获取跟自己有关的城战战场列表 
		 * @return 
		 * 
		 */		
		public function getSelfList():AttackCityList
		{
			var i:int = 0;
			var attackCity:AttackCity = null;
			var selfSphereID:int = 0;
			var ret:AttackCityList = new AttackCityList();
			
			selfSphereID = GameManager.gameMgr.wubao.sphereID;
			if (selfSphereID == 0)
				return ret;
			
			for (i = 0; i < this.length; i++)
			{
				attackCity = this.getObjByIndex(i) as AttackCity;
				if (attackCity.atkSphereID == selfSphereID || attackCity.dfsSphereID == selfSphereID)
					ret.add(attackCity);
			}
			
			return ret;
		}
		
	}
}