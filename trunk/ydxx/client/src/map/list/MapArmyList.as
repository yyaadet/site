package map.list
{
	import map.model.MapArmy;
	
	import utils.list.GameList;
	
	public class MapArmyList extends GameList
	{
		//是否有本势力军团选中
		private var _hasArmySelect:Boolean = false;
		
		//选中的军团
		private var _armySelect:MapArmy = null;
		
		private var selCount:int = 0;
		
		public function MapArmyList()
		{
			super();
		}

		/**
		 * 设置所有的军团都没有被选中 
		 * 
		 */		
		public function setAllArmyNone():void
		{
			var i:int = 0;
			var len:int = 0;
			var mapArmy:MapArmy = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				mapArmy = getObjByIndex(i) as MapArmy;
				mapArmy.selected = false;
				mapArmy.isAttack = false;
			}
			
			hasArmySelect = false;
			armySelect = null;
		}
		
		/**
		 * 鼠标点击选中军团 
		 * @param mapArmy
		 * 
		 */		
		public function setArmySelect(armyID:int):void
		{
			var mapArmy:MapArmy = getObjByID(armyID) as MapArmy;
			if (mapArmy == null) return;
			
			mapArmy.selected = true;
			setArmyExcept(mapArmy.uniqID);
			setOtherArmyAttack();
			
			hasArmySelect = true;
			armySelect = mapArmy;
			
			selCount ++;
		}
		
		/**
		 * 鼠标点击取消军团选中状态 
		 * @param armyID
		 * 
		 */		
		public function setArmyNoneSelect(armyID:int):void
		{
			var mapArmy:MapArmy = getObjByID(armyID) as MapArmy;
			if (mapArmy == null) return;
			
			mapArmy.selected = false;
			
			selCount --;
			if (selCount <= 0)
				setAllArmyNone();
		}
		
		/**
		 * 设置其他军团可攻击状态 
		 * 
		 */		
		private function setOtherArmyAttack():void
		{
			var i:int = 0;
			var len:int = 0;
			var mapArmy:MapArmy = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				mapArmy = getObjByIndex(i) as MapArmy;
				
				if (mapArmy != null)
				{
					if (mapArmy.isEne)
						mapArmy.isAttack = true;
				}
			}
		}
		
		/**
		 * 设置除了armyID军团以外其他的军团为没有选中状态 
		 * @param armyID
		 * 
		 */		
		private function setArmyExcept(armyID:int):void
		{
			if (armyID < 0) return;
			
			var i:int = 0;
			var len:int = 0;
			var mapArmy:MapArmy = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				mapArmy = getObjByIndex(i) as MapArmy;
				
				if (mapArmy.isSelf && mapArmy.uniqID != armyID)  
					mapArmy.selected = false;
			}
		}
		
		/**
		 * 根据武将ID获取军团 
		 * @param generalID
		 * @return 
		 * 
		 */		
		public function getArmyByGeneralID(generalID:int):MapArmy
		{
			if (generalID < 0) return null;
			
			var i:int = 0;
			var len:int = 0;
			var mapArmy:MapArmy = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				mapArmy = getObjByIndex(i) as MapArmy;
				
				if (mapArmy.gameGeneral != null && mapArmy.gameGeneral.uniqID == generalID)  
					return mapArmy;
			}
			
			return null;
		}
		
		//===================================================================
		//属性
		//===================================================================
		
		public function get hasArmySelect():Boolean
		{
			return _hasArmySelect;
		}
		
		public function set hasArmySelect(param:Boolean):void
		{
			_hasArmySelect = param;
		}
		
		public function get armySelect():MapArmy
		{
			return _armySelect;
		}
		
		public function set armySelect(param:MapArmy):void
		{
			_armySelect = param;
		}
		
	}
}