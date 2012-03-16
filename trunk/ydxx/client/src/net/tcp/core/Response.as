package net.tcp.core
{
	/**
	 * 响应消息包 
	 * @author StarX
	 * 
	 */	
	public class Response
	{
		//消息总长度
		private var _total:int = 0;
		
		//消息类型
		private var _type:int = 0;
		
		//发送者ID
		private var _senderID:int = 0;
		
		//消息ID
		private var _msgID:int = 0;
		
		//响应码
		private var _resID:int = 0;
		
		//响应理由
		private var _resReason:String = "";
		
		public function set total(param:int):void
		{
			this._total = param;
		}

		public function get total():int
		{
			return this._total;
		}

		public function set type(param:int):void
		{
			this._type = param;
		}

		public function get type():int
		{
			return this._type;
		}

		public function set senderID(param:int):void
		{
			this._senderID = param;
		}

		public function get senderID():int
		{
			return this._senderID;
		}

		public function set msgID(param:int):void
		{
			this._msgID = param;
		}

		public function get msgID():int
		{
			return this._msgID;
		}

		public function set resID(param:int):void
		{
			this._resID = param;
		}

		public function get resID():int
		{
			return this._resID;
		}

		public function set resReason(param:String):void
		{
			this._resReason = param;
		}

		public function get resReason():String
		{
			return this._resReason;
		}

	}
}