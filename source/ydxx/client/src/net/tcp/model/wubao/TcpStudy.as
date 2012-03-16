package net.tcp.model.wubao
{
	/**
	 * 学习技能，阵法消息包 
	 * @author bxl
	 * 
	 */	
	public class TcpStudy
	{
		//修炼武将ID
		private var _generalID:int = 0;
		
		//修炼类型  1--技能  2--阵法
		private var _type:int = 0;
		
		//技能或阵法ID
		private var _typeID:int = 0;
		
		public function get generalID():int
		{
			return _generalID;
		}

		public function set generalID(value:int):void
		{
			_generalID = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get typeID():int
		{
			return _typeID;
		}

		public function set typeID(value:int):void
		{
			_typeID = value;
		}

	}
}