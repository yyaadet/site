package net.tcp.model
{
	public class TcpChat
	{
		private var _sendID:int = 0;
		
		//特殊用户ID定义  -1：系统 -2：全国  -3:同盟
		private var _recvID:int = 0;
		
		private var _infoLen:int = 0;
		
		private var _chatInfo:String = "";
		
		public function TcpChat()
		{
		}
		
		public function get sendID():int
		{
			return _sendID;
		}
		
		public function set sendID(param:int):void
		{
			_sendID = param;
		}
		
		public function get recvID():int
		{
			return _recvID;
		}
		
		public function set recvID(param:int):void
		{
			_recvID = param;
		}
		
		public function get infoLen():int
		{
			return _infoLen;
		}
		
		public function set infoLen(param:int):void
		{
			_infoLen = param;
		}
		
		public function get chatInfo():String
		{
			return _chatInfo;
		}
		
		public function set chatInfo(param:String):void
		{
			_chatInfo = param;
		}
		
	}
}