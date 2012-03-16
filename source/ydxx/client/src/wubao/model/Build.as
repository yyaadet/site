package wubao.model
{
	import utils.PubUnit;
	
	/**
	 * 坞堡建筑 
	 * @author bxl
	 * 
	 */	
	public class Build
	{
		public static const SCHOOL:int = 1; 
		
		public static const ROOM:int = SCHOOL + 1;
		
		public static const STORE:int = ROOM + 1;
		
		public static const FACTORY:int = STORE + 1;
		
		public static const FARM:int = FACTORY + 1;
		
		public static const WOOD:int = FARM + 1;
		
		public static const MINE:int = WOOD + 1;
		
		public static const RANCH:int = MINE + 1;
		
		public static const SKIN:int = RANCH + 1;
		
		public static const MARKET:int = SKIN + 1;
		
		public static const YST:int = MARKET + 1;
		
		public static const HOSPITAL:int = YST + 1;
		
		public static const CAMP:int = HOSPITAL + 1;
		
		private var _uniqID:int = 0;
		
		//类型
		//1，书院；2，民居；3，库房；4，工坊；5，农田；6，伐木场；7，矿山；8，牧场；9，革坊；10，集市；11，议事堂；12，医馆；13，军营；
		private var _type:int = 0;
		
		//名称
		private var _name:String = "";
		
		//等级
		private var _level:int = 0;
		
		//升级结束时间戳
		private var _endTime:int = 0;
		
		//界面窗体的标题
		private var _title:String = "";

		public function Build()
		{
		}

		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}

		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}

		public function get name():String
		{
			_name = PubUnit.buildList[type];
			
			return _name;
		}
		
		public function set name(param:String):void
		{
			_name = param;
		}

		public function get level():int
		{
			return _level;
		}
		
		public function set level(param:int):void
		{
			_level = param;
		}

		public function get endTime():int
		{
			return _endTime;
		}
		
		public function set endTime(param:int):void
		{
			_endTime = param;
		}

		public function get title():String
		{
			_title = level.toString() + "级" + name;
			
			return _title;
		}
		
		public function set title(param:String):void
		{
			_title = param;
		}

	}
}