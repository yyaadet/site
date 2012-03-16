package general.model
{
	import utils.PubUnit;
	
	/**
	 * 技能类 
	 * @author bxl
	 * 
	 */	
	public class Skill
	{
		//技能ID
		private var _uniqID:int = 0;
		
		//技能名称
		private var _skillName:String = "";
		
		//技能类型
		private var _skillType:int = 0;
		
		//技能类型名称
		private var _skillTypeName:String = "";
		
		//兵种系ID
		private var _typeID:int = 0;
		
		//兵种系名称
		private var _typeName:String = "";
		
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
		private var _condi:String = "";
		
		//技能说明
		private var _info:String = "";
		
		public function Skill()
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

		public function get skillName():String
		{
			return _skillName;
		}

		public function set skillName(value:String):void
		{
			_skillName = value;
		}

		public function get skillType():int
		{
			return _skillType;
		}

		public function set skillType(value:int):void
		{
			_skillType = value;
		}

		public function get skillTypeName():String
		{
			_skillTypeName = PubUnit.skillType[skillType];
			return _skillTypeName;
		}

		public function set skillTypeName(value:String):void
		{
			_skillTypeName = value;
		}

		public function get typeID():int
		{
			return _typeID;
		}

		public function set typeID(value:int):void
		{
			_typeID = value;
		}

		public function get typeName():String
		{
			return _typeName;
		}

		public function set typeName(value:String):void
		{
			_typeName = value;
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