package net.tcp.model.wubao
{
	/**
	 * 合成装备
	 * @author StarX
	 * 
	 */	
	public class TcpCompose
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//装备类型
		private var _type:int = 0;
		
		//装备等级
		private var _level:int = 0;
		
		//合成数量
		private var _num:int = 0;
		
		public function get wbID():int
		{
			return _wbID;
		}
		
		public function set wbID(param:int):void
		{
			_wbID = param;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function set level(param:int):void
		{
			_level = param;
		}
		
		public function get num():int
		{
			return _num;
		}
		
		public function set num(param:int):void
		{
			_num = param;
		}
		
	}
}