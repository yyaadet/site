package general.model
{
	/**
	 * 阵型类 
	 * @author bxl
	 * 
	 */	
	public class Zhen
	{
		//阵型ID
		private var _uniqID:int = 0;
		
		//阵型名称
		private var _zhenName:String = "无";
		
		//兵种系1ID
		private var _type1ID:int = 0;
		
		//兵种系2ID
		private var _type2ID:int = 0;
		
		//攻击
		private var _attack:int = 0;
		
		//防御
		private var _defense:int = 0;
		
		//机动
		private var _speed:int = 0;
		
		//所需武力
		private var _min1:int = 0;
		
		private var _max1:int = 0;
		
		//所需智力
		private var _min2:int = 0;
		
		private var _max2:int = 0;
		
		//所需政治
		private var _min3:int = 0;
		
		private var _max3:int = 0;
		
		//所需功勋
		private var _pre:int = 0;
		
		//修炼条件
		private var _condi:String = "无";
		
		//阵型说明
		private var _info:String = "无";
		
		public function Zhen()
		{
		}

		public function get uniqID():int
		{
			return _uniqID;
		}

		public function set uniqID(value:int):void
		{
			_uniqID = value;
		}

		public function get zhenName():String
		{
			return _zhenName;
		}

		public function set zhenName(value:String):void
		{
			_zhenName = value;
		}

		public function get type1ID():int
		{
			return _type1ID;
		}

		public function set type1ID(value:int):void
		{
			_type1ID = value;
		}

		public function get type2ID():int
		{
			return _type2ID;
		}

		public function set type2ID(value:int):void
		{
			_type2ID = value;
		}

		public function get attack():int
		{
			return _attack;
		}

		public function set attack(value:int):void
		{
			_attack = value;
		}

		public function get defense():int
		{
			return _defense;
		}

		public function set defense(value:int):void
		{
			_defense = value;
		}

		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function get min1():int
		{
			return _min1;
		}

		public function set min1(value:int):void
		{
			_min1 = value;
		}

		public function get max1():int
		{
			return _max1;
		}

		public function set max1(value:int):void
		{
			_max1 = value;
		}

		public function get min2():int
		{
			return _min2;
		}

		public function set min2(value:int):void
		{
			_min2 = value;
		}

		public function get max2():int
		{
			return _max2;
		}

		public function set max2(value:int):void
		{
			_max2 = value;
		}

		public function get min3():int
		{
			return _min3;
		}

		public function set min3(value:int):void
		{
			_min3 = value;
		}

		public function get max3():int
		{
			return _max3;
		}

		public function set max3(value:int):void
		{
			_max3 = value;
		}

		public function get pre():int
		{
			return _pre;
		}

		public function set pre(value:int):void
		{
			_pre = value;
		}

		public function get condi():String
		{
			return _condi;
		}

		public function set condi(value:String):void
		{
			_condi = value;
		}

		public function get info():String
		{
			return _info;
		}

		public function set info(value:String):void
		{
			_info = value;
		}

	}
}