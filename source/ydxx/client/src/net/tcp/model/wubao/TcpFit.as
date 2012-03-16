package net.tcp.model.wubao
{
	/**
	 * 配兵
	 * @author StarX
	 * 
	 */	
	public class TcpFit
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//武将ID
		private var _generalID:int = 0;
		
		//士兵数量
		private var _num:int = 0;
		
		//阵型ID
		private var _zhenID:int = 0;
		
		//主武器
		private var _w1Type:int = 0;
		
		//主武器等级
		private var _w1Level:int = 0;
		
		//副武器
		private var _w2Type:int = 0;
		
		//副武器等级
		private var _w2Level:int = 0;
		
		//护甲
		private var _w3Type:int = 0;
		
		//护甲等级
		private var _w3Level:int = 0;
		
		//特殊物品
		private var _w4Type:int = 0;
		
		//特殊物品等级
		private var _w4Level:int = 0;
		
		public function get wbID():int
		{
			return _wbID;
		}
		
		public function set wbID(param:int):void
		{
			_wbID = param;
		}
		
		public function get generalID():int
		{
			return _generalID;
		}
		
		public function set generalID(param:int):void
		{
			_generalID = param;
		}
		
		public function get num():int
		{
			return _num;
		}
		
		public function set num(param:int):void
		{
			_num = param;
		}
		
		public function get zhenID():int
		{
			return _zhenID;
		}
		
		public function set zhenID(param:int):void
		{
			_zhenID = param;
		}
		
		public function get w1Type():int
		{
			return _w1Type;
		}

		public function set w1Type(value:int):void
		{
			_w1Type = value;
		}
		
		public function get w1Level():int
		{
			return _w1Level;
		}

		public function set w1Level(value:int):void
		{
			_w1Level = value;
		}
		
		public function get w2Type():int
		{
			return _w2Type;
		}

		public function set w2Type(value:int):void
		{
			_w2Type = value;
		}
		
		public function get w2Level():int
		{
			return _w2Level;
		}

		public function set w2Level(value:int):void
		{
			_w2Level = value;
		}
		
		public function get w3Type():int
		{
			return _w3Type;
		}

		public function set w3Type(value:int):void
		{
			_w3Type = value;
		}
		
		public function get w3Level():int
		{
			return _w3Level;
		}

		public function set w3Level(value:int):void
		{
			_w3Level = value;
		}
		
		public function get w4Type():int
		{
			return _w4Type;
		}

		public function set w4Type(value:int):void
		{
			_w4Type = value;
		}
		
		public function get w4Level():int
		{
			return _w4Level;
		}

		public function set w4Level(value:int):void
		{
			_w4Level = value;
		}
		
	}
}