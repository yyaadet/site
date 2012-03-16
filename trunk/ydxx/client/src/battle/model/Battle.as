package battle.model
{
	/**
	 * 战役 
	 * @author bxl
	 * 
	 */	
	public class Battle
	{
		//战役ID
		private var _uniqID:int;
		
		//战役背景图片链接地址
		private var _picURL:String;
		
		//战役标题
		private var _title:String;
		
		//战役说明
		private var _info:String;
		
		//战役说明位置(未用到)
		private var _infoPos:int = 3;
		
		public function get uniqID():int
		{
			return _uniqID;
		}

		public  function set uniqID(param:int):void
		{
			_uniqID = param;
		}

		public function get picURL():String
		{
			return _picURL;
		}

		public  function set picURL(param:String):void
		{
			_picURL = param;
		}

		public function get title():String
		{
			return _title;
		}

		public  function set title(param:String):void
		{
			_title = param;
		}

		public function get info():String
		{
			return _info;
		}

		public  function set info(param:String):void
		{
			_info = param;
		}

		public function get infoPos():int
		{
			return _infoPos;
		}

		public  function set infoPos(param:int):void
		{
			_infoPos = param;
		}

	}
}