package wubao.model
{
	/**
	 * 爵位 
	 * @author bxl
	 * 
	 */	
	public class Dignitie
	{
		private var _uniqID:int = 0;
		
		//名称
		private var _digName:String = "";
		
		//声望
		private var _prestige:int = 0;
		
		//可招募武将数目
		private var _generalMax:int = 0;
		
		public function Dignitie()
		{
		}

		public function get uniqID():int
		{
			return _uniqID;
		}

		public function set uniqID(value:int):void
		{
			_uniqID = value;
		}

		public function get digName():String
		{
			return _digName;
		}

		public function set digName(value:String):void
		{
			_digName = value;
		}

		public function get prestige():int
		{
			return _prestige;
		}

		public function set prestige(value:int):void
		{
			_prestige = value;
		}

		public function get generalMax():int
		{
			return _generalMax;
		}

		public function set generalMax(value:int):void
		{
			_generalMax = value;
		}

	}
}