package net.tcp.model.deal
{
	/**
	 * 撤销交易 
	 * @author bxl
	 * 
	 */	
	public class TcpCancel
	{
		//类型 1--挂单 2--出售武器
		private var _type:int = 0;
		
		//交易ID
		private var _uniqID:int = 0;
		
		public function TcpCancel()
		{
		}

		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}
		
	}
}