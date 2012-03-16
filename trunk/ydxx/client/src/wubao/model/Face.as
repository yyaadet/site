package wubao.model
{
	/**
	 * 全局头像 
	 * @author StarX
	 * 
	 */	
	public class Face
	{
		//头像ID
		private var _uniqID:int = 0;

		//性别
		//0 女 1 男
		private var _sex:int = 0;

		//头像URL地址
		private var _url:String;

		public function Face()
		{
			
		}

		public function set uniqID(param:int):void
		{
			this._uniqID = param;
		}

		public function get uniqID():int
		{
			return this._uniqID;
		}

		public function set sex(param:int):void
		{
			this._sex = param;
		}

		public function get sex():int
		{
			return this._sex;
		}

		public function set url(param:String):void
		{
			this._url = param;
		}

		public function get url():String
		{
			return this._url;
		}

	}
}