package city.list
{
	import city.model.AttackArmy;
	
	import utils.list.GameList;

	public class AttackArmyList extends GameList
	{
		public function AttackArmyList()
		{
			super();
		}
		
		public function getByUserID(userID:int):AttackArmy
		{
			var i:int = 0;
			var len:int = 0;
			var attackArmy:AttackArmy = null;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				attackArmy = getObjByIndex(i) as AttackArmy;
				if (attackArmy != null && attackArmy.gameUser != null && attackArmy.gameUser.uniqID == userID)
					return attackArmy;
			}
			
			return attackArmy;
		}
		
	}
}