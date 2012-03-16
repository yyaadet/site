package wubao.list
{
	import utils.list.GameList;
	
	import wubao.model.Weapon;
	
	/**
	 * 士兵装备列表类 
	 * @author bxl
	 * 
	 */	
	public class WeaponList extends GameList
	{
		
		public function WeaponList()
		{
			super();
		}
		
		/**
		 * 根据类型和等级获取对应的装备 
		 * @param type
		 * @param level
		 * @return 
		 * 
		 */		
		public function getWeapon(type:int, level:int):Weapon
		{
			var i:int = 0;
			var len:int = 0;
			var ret:Weapon = null;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				ret = getObjByIndex(i) as Weapon;
				if (ret != null && ret.type == type && ret.level == level)
					return ret;
			}
			
			return ret;
		}
		
		/**
		 * 获取装备列表中数目不为0的空闲装备 
		 * @return 
		 * 
		 */		
		public function getWpnList():WeaponList
		{
			var wList:WeaponList = new WeaponList();
			var i:int = 0;
			var weapon:Weapon = null;
			
			wList.removeAll();
			
			for (i = 0;i < this.length; i++)
			{
				weapon = getObjByIndex(i) as Weapon;
				if (weapon != null && weapon.num > 0)
					wList.add(weapon);
			}
			
			return wList;
		}
		
	}
}