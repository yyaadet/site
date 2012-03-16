package general.list
{
	import general.model.Skill;
	
	import utils.list.GameList;

	public class SkillList extends GameList
	{
		public function SkillList()
		{
			super();
		}
		
		/**
		 * 获取统率技能 
		 * @param typeID
		 * @return 
		 * 
		 */		
		public function getFollowSkill(typeID:int):Skill
		{
			var i:int = 0;
			var len:int = 0;
			var ret:Skill = null;
			var skill:Skill = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				skill = getObjByIndex(i) as Skill;
				
				if (skill.typeID == typeID && skill.skillType == 1)
				{
					ret = skill;
					return ret;
				}
			}
			
			return ret; 
		}
		
		/**
		 * 获取战斗技能 
		 * @param typeID
		 * @return 
		 * 
		 */		
		public function getWarSkill(typeID:int):Skill
		{
			var i:int = 0;
			var len:int = 0;
			var ret:Skill = null;
			var skill:Skill = null;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				skill = getObjByIndex(i) as Skill;
				
				if (skill.typeID == typeID && skill.skillType == 2)
				{
					ret = skill;
					return ret;
				}
			}
			
			return ret; 
		}
		
		/**
		 * 获取兵种系的技能列表 
		 * @param typeID
		 * @return 
		 * 
		 */		
		public function getListByType(typeID:int):SkillList
		{
			var i:int = 0;
			var len:int = 0;
			var ret:SkillList = new SkillList();
			var skill:Skill = null;
			
			len = this.length;
			
			for (i = len - 1; i >= 0; i--)
			{
				skill = getObjByIndex(i) as Skill;
				
				if (skill.typeID == typeID)
					ret.add(skill);
			}
			
			return ret; 
		}
		
	}
}