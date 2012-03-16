package net.tcp.model.map
{
	/**
	 * 战争通知 
	 * @author bxl
	 * 
	 */	
	public class TcpWar
	{
		//类型
		//1。军团野战
		//对象1：军团1
		//对象2：军团2
		//2。军团攻城
		//对象1：军团
		//对象2：城池
		private var _type:int = 0;

		//对象1ID
		private var _obj1ID:int = 0;

		//对象1死亡兵力
		private var _obj1Die:int = 0;

		//对象1伤兵数
		private var _obj1Hurt:int = 0;

		//对象1爆发技能
		private var _obj1Skill:int = 0;

		//对象2ID
		private var _obj2ID:int = 0;

		//对象2死亡兵力
		private var _obj2Die:int = 0;

		//对象2伤兵数
		private var _obj2Hurt:int = 0;

		//对象2爆发技能
		private var _obj2Skill:int = 0;
		
		//城防降低值
		private var _defense:int = 0;

		public function TcpWar()
		{
			
		}

		public function set type(param:int):void
		{
			this._type = param;
		}

		public function get type():int
		{
			return this._type;
		}

		public function set obj1ID(param:int):void
		{
			this._obj1ID = param;
		}

		public function get obj1ID():int
		{
			return this._obj1ID;
		}

		public function set obj1Die(param:int):void
		{
			this._obj1Die = param;
		}

		public function get obj1Die():int
		{
			return this._obj1Die;
		}

		public function set obj1Hurt(param:int):void
		{
			this._obj1Hurt = param;
		}

		public function get obj1Hurt():int
		{
			return this._obj1Hurt;
		}

		public function set obj1Skill(param:int):void
		{
			this._obj1Skill = param;
		}

		public function get obj1Skill():int
		{
			return this._obj1Skill;
		}

		public function set obj2ID(param:int):void
		{
			this._obj2ID = param;
		}

		public function get obj2ID():int
		{
			return this._obj2ID;
		}

		public function set obj2Die(param:int):void
		{
			this._obj2Die = param;
		}

		public function get obj2Die():int
		{
			return this._obj2Die;
		}

		public function set obj2Hurt(param:int):void
		{
			this._obj2Hurt = param;
		}

		public function get obj2Hurt():int
		{
			return this._obj2Hurt;
		}

		public function set obj2Skill(param:int):void
		{
			this._obj2Skill = param;
		}

		public function get obj2Skill():int
		{
			return this._obj2Skill;
		}

		public function set defense(param:int):void
		{
			this._defense = param;
		}

		public function get defense():int
		{
			return this._defense;
		}

	}
}