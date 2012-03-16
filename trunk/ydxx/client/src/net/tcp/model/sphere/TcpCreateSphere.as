package net.tcp.model.sphere
{
	/**
	 * 创建势力 
	 * @author bxl
	 * 
	 */	
	public class TcpCreateSphere
	{
		//坞堡ID
		private var _wbID:int = 0;
		
		//势力名称
		private var _name:String = ""; 

		//势力简介
		private var _content:String = ""; 

		public function get wbID():int
		{
			return _wbID;
		}
		
		public function set wbID(param:int):void
		{
			_wbID = param;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(param:String):void
		{
			_name = param;
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