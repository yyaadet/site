package net.tcp.model.wubao
{
	/**
	 * 加速升级
	 * @author StarX
	 * 
	 */	
	public class TcpAcce
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//加速类型
		private var _type:int = 0;
		
		//加速对象ID 
		private var _typeID:int = 0;
		
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
		
		public function get typeID():int
		{
			return _typeID;
		}
		
		public function set typeID(param:int):void
		{
			_typeID = param;
		}
		
	}
}