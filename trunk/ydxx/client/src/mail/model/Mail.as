package mail.model
{
	import sphere.model.Sphere;
	
	import utils.GameManager;
	import utils.PubUnit;
	
	import wubao.model.User;
	
	/**
	 * 邮件 
	 * @author StarX
	 * 
	 */	
	[Bindable]
	public class Mail
	{
		//邮件ID
		private var _uniqID:int;

		//发送者ID，对应GameSphere类中的gsID
		private var _senderID:int;

		//发送者姓名
		private var _senderName:String = "";

		//接受者ID
		private var _receiveID:int;

		//接受者姓名
		private var _receiveName:String = "";
		
		//邮件类型 0：普通，1：申请加入势力，2：申请结盟, 3:系统
		private var _type:int = 0;

		//标题
		private var _title:String;

		//内容
		private var _content:String;
		
		//发送时间戳
		private var _sendTime:int = 0;
		
		//日期
		private var _mailDate:String = "";

		//是否已读，0：未读，1：已读
		private var _isRead:int;
		
		//是否已读
		private var _isReadStr:String = "";
		
		//是否选中，用作DataGrid的ItemRender
		private var _isSel:Boolean = false;
		
		//以下字段是在加入势力类型邮件的情况下用到
		
		//申请加入势力的用户
		private var _gameUser:User = null;
		
		//姓名
		private var _userName:String = "";

		//声望
		private var _userPrestige:int = 0;
		
		//官位名称
		private var _offName:String = "无";
		
		//所在
		private var _placeName:String = "";
		
		//以下字段是在同盟类型邮件的情况下用到
		
		//发起同盟势力
		private var _gameSphere:Sphere = null;

		//势力名称
		private var _sphereName:String = "";
		
		//等级名称
		private var _levelName:String = "";
		
		//用户数
		private var _userNum:int = 0;
		
		//威望
		private var _prestige:int = 0;
		
		public function set uniqID(param:int):void
		{
			this._uniqID = param;
		}

		public function get uniqID():int
		{
			return this._uniqID;
		}

		public function set senderID(param:int):void
		{
			this._senderID = param;
		}

		public function get senderID():int
		{
			return this._senderID;
		}

		public function set senderName(param:String):void
		{
			this._senderName = param;
		}

		public function get senderName():String
		{
			return this._senderName;
		}

		public function set type(param:int):void
		{
			this._type = param;
			
			if (_type == 1)
				gameUser = GameManager.gameMgr.userList.getObjByID(senderID) as User;
			else if (_type == 2)
			{
				var userTemp:User = GameManager.gameMgr.userList.getObjByID(senderID) as User;
				if (userTemp != null)  
					gameSphere = GameManager.gameMgr.sphereList.getObjByID(userTemp.sphereID) as Sphere;
			}
		}

		public function get type():int
		{
			return this._type;
		}

		public function set receiveID(param:int):void
		{
			this._receiveID = param;
		}

		public function get receiveID():int
		{
			return this._receiveID;
		}

		public function set receiveName(param:String):void
		{
			this._receiveName = param;
		}

		public function get receiveName():String
		{
			return this._receiveName;
		}

		public function set title(param:String):void
		{
			this._title = param;
		}

		public function get title():String
		{
			return this._title;
		}

		public function set content(param:String):void
		{
			this._content = param;
		}

		public function get content():String
		{
			return this._content;
		}

		public function set isRead(param:int):void
		{
			this._isRead = param;
		}

		public function get isRead():int
		{
			return this._isRead;
		}

		public function set isReadStr(param:String):void
		{
			this._isReadStr = param;
		}

		public function get isReadStr():String
		{
			_isReadStr = isRead == 0 ? "未读" : "已读"; 
			
			return this._isReadStr;
		}

		public function set sendTime(param:int):void
		{
			this._sendTime = param;
		}
		
		public function get sendTime():int
		{
			return this._sendTime;
		}

		public function set mailDate(param:String):void
		{
			this._mailDate = param;
		}
		
		public function get mailDate():String
		{
			_mailDate = PubUnit.getDateStr(sendTime);
			
			return this._mailDate;
		}

		public function set isSel(param:Boolean):void
		{
			this._isSel = param;
		}
		
		public function get isSel():Boolean
		{
			return this._isSel;
		}

		public function set gameUser(param:User):void
		{
			this._gameUser = param;
		}

		public function get gameUser():User
		{
			return this._gameUser;
		}

		public function set userName(param:String):void
		{
			this._userName = param;
		}

		public function get userName():String
		{
			if (gameUser != null)
				_userName = gameUser.userName;
				
			return this._userName;
		}

		public function get userPrestige():int
		{
			if (gameUser != null)
				_userPrestige = gameUser.prestige;
				
			return _userPrestige;
		}
		
		public function set userPrestige(param:int):void
		{
			_userPrestige = param;
		}

		public function get offName():String
		{
			if (gameUser != null)
				_offName = gameUser.offName;
				
			return _offName;
		}

		public function set offName(value:String):void
		{
			_offName = value;
		}

		public function get placeName():String
		{
			if (gameUser != null)
				_placeName = gameUser.place;
				
			return _placeName;
		}

		public function set placeName(value:String):void
		{
			_placeName = value;
		}

		public function get gameSphere():Sphere
		{
			return _gameSphere;
		}
		
		public function set gameSphere(param:Sphere):void
		{
			_gameSphere = param;
		}

		public function get sphereName():String
		{
			if (gameSphere != null)
				_sphereName = gameSphere.sphereName;
				
			return _sphereName;
		}
		
		public function set sphereName(param:String):void
		{
			_sphereName = param;
		}

		public function get levelName():String
		{
			if (gameSphere != null)
				_levelName = gameSphere.levelName;
				
			return _levelName;
		}
		
		public function set levelName(param:String):void
		{
			_levelName = param;
		}

		public function get userNum():int
		{
			if (gameSphere != null)
				_userNum = gameSphere.userNum;
				
			return _userNum;
		}
		
		public function set userNum(param:int):void
		{
			_userNum = param;
		}

		public function get prestige():int
		{
			if (gameSphere != null)
				_prestige = gameSphere.prestige;
				
			return _prestige;
		}
		
		public function set prestige(param:int):void
		{
			_prestige = param;
		}

	}
}