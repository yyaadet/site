package net.tcp.model.task
{
	public class TcpBonus
	{
		private var _taskID:int = 0;
		
		public function TcpBonus()
		{
		}

		public function get taskID():int
		{
			return _taskID;
		}
		
		public function set taskID(param:int):void
		{
			_taskID = param;
		}

	}
}