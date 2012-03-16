package wubao.model
{
	import utils.PubUnit;
	
	import wubao.list.WeaponList;
	
	/**
	 * 仓库 
	 * @author bxl
	 * 
	 */	
	public class Store
	{
		//士兵装备列表
		private var _weaponList:WeaponList = new WeaponList();
		
		public function Store()
		{
			
		}
		
		public function getWeaponNum(type:int, level:int):int
		{
			var weapon:Weapon = null;
			
			weapon = _weaponList.getWeapon(type, level) as Weapon;
			if (weapon != null)
				return weapon.num;
			
			return 0;
		} 

		//=========================================================================================
		// 属性
		//=========================================================================================
		
		/**
		 * 获取仓库的最大存储种类数 
		 * @return 
		 * 
		 */		
		public function get total():int
		{
			var ret:int = PubUnit.getStoreMax();
			
			return ret;
		}
		
		/**
		 * 获取剩余可存储种类数 
		 * @return 
		 * 
		 */		
		public function get left():int
		{
			var ret:int = 0;
			var max:int = PubUnit.getStoreMax();
			var useNum:int = weaponList.getWpnList().length;
			
			ret = max - useNum;
			
			return ret;
		}
		
		public function get weaponList():WeaponList
		{
			return _weaponList;
		}

		public function set weaponList(value:WeaponList):void
		{
			_weaponList = value;
		}
		
	}
}