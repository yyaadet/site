package battle.model
{
	/**
	 * 关卡 
	 * @author bxl
	 * 
	 */	
	public class Gateway
	{
		//关卡ID
		private var _uniqID:int;
		
		//战役ID
		private var _battleID:int;
		
		//关卡名称
		private var _name:String;
		
		//关卡坐标
		private var _x:int;

		private var _y:int;
		
		//关卡奖励功勋
		private var _prestige:int;
		
		private var _type:int = 0;
		
		private var _level:int = 0;
		
		private var _num:int = 0;
		
		//可攻打次数上限
		private var _countMax:int = 0;
		
		//已攻打次数
		private var _count:int = 0;
		
		//掉装备几率
		private var _per:int = 0;
		
		//关卡冷却时间(未用到)
		private var _CD:int = 0;

		public function get uniqID():int
		{
			return _uniqID;
		}

		public  function set uniqID(param:int):void
		{
			_uniqID = param;
		}

		public function get battleID():int
		{
			return _battleID;
		}

		public  function set battleID(param:int):void
		{
			_battleID = param;
		}

		public function get name():String
		{
			return _name;
		}

		public  function set name(param:String):void
		{
			_name = param;
		}

		public function get x():int
		{
			return _x;
		}

		public  function set x(param:int):void
		{
			_x = param;
		}

		public function get y():int
		{
			return _y;
		}

		public  function set y(param:int):void
		{
			_y = param;
		}

		public function get prestige():int
		{
			return _prestige;
		}

		public  function set prestige(param:int):void
		{
			_prestige = param;
		}

		public function get type():int
		{
			return _type;
		}

		public  function set type(param:int):void
		{
			_type = param;
		}

		public function get level():int
		{
			return _level;
		}

		public  function set level(param:int):void
		{
			_level = param;
		}

		public function get num():int
		{
			return _num;
		}

		public  function set num(param:int):void
		{
			_num = param;
		}

		public function get countMax():int
		{
			return _countMax;
		}

		public  function set countMax(param:int):void
		{
			_countMax = param;
		}

		public function get count():int
		{
			return _count;
		}

		public  function set count(param:int):void
		{
			_count = param;
		}

		public function get per():int
		{
			return _per;
		}

		public  function set per(param:int):void
		{
			_per = param;
		}

		public function get CD():int
		{
			return _CD;
		}

		public  function set CD(param:int):void
		{
			_CD = param;
		}
	}
}