package net.tcp.model
{
	/**
	 * 发送邮件 
	 * @author StarX
	 * 
	 */	
	public class TcpMail
	{
		//接收方ID
		private var _userID:int = 0;
		
		//类型
		private var _type:int = 0;
		
		//标题
		private var _title:String = "";
		
		//内容
		private var _content:String = "";
		
		public function get userID():int
		{
			return _userID;
		}
		
		public function set userID(param:int):void
		{
			_userID = param;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(param:String):void
		{
			_title = param;
		}
		
		public function get content():String
		{
			return _content;
		}
		
		public function set content(param:String):void
		{
			_content = param;
		}
		
	}
}