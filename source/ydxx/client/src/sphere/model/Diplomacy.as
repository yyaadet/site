package sphere.model
{
	import utils.GameManager;
	import utils.PubUnit;
	
	/**
	 * 外交关系 
	 * @author bxl
	 * 
	 */	
	public class Diplomacy
	{
		private var _uniqID:int = 0;
		
		//类型  1.同盟，2.敌对
		private var _type:int = 0;
		
		//己方势力ID
		private var _selfID:int = 0;
		
		//对方势力ID
		private var _targetID:int = 0;
		
		//对方势力名称
		private var _targetName:String = "";
		
		//对方势力等级
		private var _levelName:String = "";
		
		//开始时间
		private var _startTime:int = 0;
		
		//结束时间
		private var _endTime:int = 0;
		
		//结束日期
		private var _endTimeStr:String = "";
		
		public function Diplomacy()
		{
		}
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}

		public function get type():int
		{
			return _type;
		}
		
		public function set type(param:int):void
		{
			_type = param;
		}
		
		public function get selfID():int
		{
			return _selfID;
		}
		
		public function set selfID(param:int):void
		{
			_selfID = param;
		}
		
		public function get targetID():int
		{
			return _targetID;
		}
		
		public function set targetID(param:int):void
		{
			_targetID = param;
		}
		
		public function get targetName():String
		{
			var sphereID:int = 0;
			if (targetID == GameManager.gameMgr.wubao.sphereID)
				sphereID = selfID;
			else
				sphereID = targetID;
				
			var gameSphere:Sphere = GameManager.gameMgr.sphereList.getObjByID(sphereID) as Sphere;
			if (gameSphere != null)
				_targetName = gameSphere.sphereName;
				
			return _targetName;
		}
		
		public function set targetName(param:String):void
		{
			_targetName = param;
		}
		
		public function get levelName():String
		{
			var sphereID:int = 0;
			if (targetID == GameManager.gameMgr.wubao.sphereID)
				sphereID = selfID;
			else
				sphereID = targetID;
				
			var gameSphere:Sphere = GameManager.gameMgr.sphereList.getObjByID(sphereID) as Sphere;
			if (gameSphere != null)
				_levelName = gameSphere.levelName;
				
			return _levelName;
		}
		
		public function set levelName(param:String):void
		{
			_levelName = param;
		}
		
		public function get startTime():int
		{
			return _startTime;
		}
		
		public function set startTime(param:int):void
		{
			_startTime = param;
		}
		
		public function get endTime():int
		{
			return _endTime;
		}
		
		public function set endTime(param:int):void
		{
			_endTime = param;
		}

		public function get endTimeStr():String
		{
			_endTimeStr = PubUnit.getDateStr(endTime);
			
			return _endTimeStr;
		}
		
		public function set endTimeStr(param:String):void
		{
			_endTimeStr = param;
		}

	}
}