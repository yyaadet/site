package net.tcp.model.sphere
{
	/**
	 * 修改势力简介
	 * @author StarX
	 * 
	 */	
	public class TcpModify
	{
		//势力ID 
		private var _sphereID:int = 0;
		
		private var _content:String = "";
		
		public function get sphereID():int
		{
			return _sphereID;
		}
		
		public function set sphereID(param:int):void
		{
			_sphereID = param;
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