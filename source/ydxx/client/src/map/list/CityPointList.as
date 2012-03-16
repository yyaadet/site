package map.list
{
	import map.model.CityPoint;
	
	import utils.PubUnit;
	import utils.list.GameList;
	
	/**
	 * 地图上的城池点列表 
	 * @author bxl
	 * 
	 */	
	public class CityPointList extends GameList
	{
		public function CityPointList()
		{
			super();
		}
		
		//================================================================================
		// 创建角色
		//================================================================================
		
		public function resetAllColor():void
		{
			var i:int = 0;
			var len:int = this.length;
			var cityPoint:CityPoint = null;
			
			for (i = 0; i < len; i++)
			{
				cityPoint = hashMap.getValueByIndex(i) as CityPoint;
				if (cityPoint.gameCity.isAlloted == 0 || cityPoint.gameCity.wubaoNum < 1)
				{
					cityPoint.pColor = PubUnit.WHITE;
					cityPoint.draw();
				}
				else
				{
					cityPoint.pColor = PubUnit.GREEN;
					cityPoint.draw1(PubUnit.GREEN, PubUnit.WHITE);
				}	
				
			}
		}
		
		public function clearAllGlow():void
		{
			var i:int = 0;
			var len:int = this.length;
			var cityPoint:CityPoint = null;
			
			for (i = 0; i < len; i++)
			{
				cityPoint = hashMap.getValueByIndex(i) as CityPoint;
				PubUnit.clearGlow(cityPoint);
			}
		}
		
		//================================================================================
		// 小地图
		//================================================================================
		
		//================================================================================
		// 城池选择
		//================================================================================
		
	}
}