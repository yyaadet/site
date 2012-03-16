package net.tcp.core
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * 发送消息包 
	 * @author bxl
	 * 
	 */	
	public class Request
	{
		//消息总长度
		private var _total:uint = 0;
		
		//消息类型
		private var _type:uint = 0;
		
		//发送者ID
		private var _sendID:uint = 0;
		
		//消息ID
		private var _msgID:uint = 0;
		
		//消息体
		private var tcpBody:ByteArray = new ByteArray();
		
		public function Request(p_type:uint, p_sendID:uint, p_msgID:uint, body:ByteArray)
		{
			_type = p_type;
			_sendID = p_sendID;
			_msgID = p_msgID;
			
			if (body)
			{
				tcpBody.writeBytes(body, 0, body.length);
				_total = 16 + tcpBody.length; 
			} else 
				_total = 16;
		}
		
		public function pack():ByteArray
		{
			var result:ByteArray = new ByteArray();
			
			result.endian = Endian.BIG_ENDIAN;
			result.writeUnsignedInt(_total);
			result.writeUnsignedInt(_type);
			result.writeUnsignedInt(_sendID);
			result.writeUnsignedInt(_msgID);
			
			if (tcpBody.length > 0)
				result.writeBytes(tcpBody, 0, tcpBody.length);
				
			return result;
		}
		
		public function get type():uint
		{
			return _type;
		}
		
		public function get body():ByteArray
		{
			return tcpBody;
		}
		
		public function get sendID():uint
		{
			return _sendID;
		}
		
		public function get msgID():uint
		{
			return _msgID;
		}
		
		public function get total():int
		{
			return _total;
		}
		
	}
}