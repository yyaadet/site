package general.model
{
	import city.model.City;
	
	import general.list.SkillList;
	import general.list.ZhenList;
	
	import utils.GameManager;
	import utils.GeneralDes;
	import utils.PubUnit;
	
	import wubao.model.Face;
	import wubao.model.Official;
	import wubao.model.User;
	import wubao.model.UserTreasure;
	import wubao.model.WuBao;
	
	
	/**
	 * 武将 
	 * @author StarX
	 * 
	 */	
	[Bindable]
	public class General
	{
		//兵种  1，骑兵系；2，弩兵系；3，步兵系；4，弓骑系；5弩车系；6，甲车系
		public static const QI:int = 1;
		
		public static const NU:int = QI + 1;
		
		public static const BU:int = NU + 1;
		
		public static const GONGQI:int = BU + 1;
		
		public static const NUCHE:int = GONGQI + 1;
		
		public static const JIACHE:int = NUCHE + 1;
		
		//武将ID
		private var _uniqID:int;

		//用户ID
		private var _userID:int;
		
		//用户名称
		private var _userName:String = "";
		
		//所属势力
		private var _sphereName:String = "无";
		
		//武将类型 0：普通，1：历史名将
		private var _type:int = 0;

		//姓
		private var _firstName:String = "";

		//名
		private var _lastName:String = "";

		//字
		private var _zi:String = "无";
		
		//姓名
		private var _generalName:String = "无";

		//出生年份
		private var _bornYear:int;
		
		//出场年份
		private var _initYear:int = 0;
		
		private var _initYearStr:String = "";
		
		//性别,0：女，1:男
		private var _sex:int;

		//头像ID
		private var _faceID:int;
		
		//头像地址
		private var _faceURL:String = "";

		//死亡年份
		private var _dieYear:int;

		//武力(初始值)
		private var _kongfu:int;

		//移动(初始值)
		private var _speed:int;

		//政治(初始值)
		private var _polity:int;

		//智力(初始值)
		private var _intelligence:int;
		
		//忠诚度(初始值)
		private var _faith:int = 0;
		
		//武力(当前值)
		private var _kongfuCur:int;

		//政治(当前值)
		private var _polityCur:int;

		//智力(当前值)
		private var _intelligenceCur:int;
		
		//忠诚度(当前值)
		private var _faithCur:int = 0;
		
		//武力值 + 增加值
		private var _kongfuStr:String = "";

		//政治值 + 增加值
		private var _polityStr:String = "";
		
		//智力值 + 增加值
		private var _intelligenceStr:String = "";
		
		//是否死亡，1：死亡，0：未死亡
		private var _isDead:int;
		
		//最低友好度
		private var _friend:int = 0

		//武将带兵数
		private var _follows:int = 0;

		//武器ID
		private var _weaponID:int = 0;
		
		//武器名称
		private var _weaponName:String = "无";
		
		//智力书籍ID
		private var _intellBookID:int = 0;
		
		//智力书籍名称
		private var _intellBookName:String = "无";
		
		//政治书籍ID
		private var _polityBookID:int = 0;
		
		//政治书籍名称
		private var _polityBookName:String = "无";
		
		//坐骑ID
		private var _horseID:int = 0;
		
		//坐骑名称
		private var _horseName:String = "无";
		
		//介绍
		private var _description:String = "无";

		//所在  1:坞堡，2：城池 3：军团 4：路途
		private var _place:int = 0;
		
		//所在城池  字段值为城池ID
		//所在军团  字段值为军团ID
		private var _placeID:int = 0;
		
		//所在名称
		private var _placeName:String = "";
		
		//任务类型 0-空闲  1-修炼
		private var _misType:int = 0;
		
		//技能标志位
		private var _skill:uint = 0;
		
		//技能列表
		private var _skillList:SkillList = new SkillList();
		
		//阵型
		private var _zhen:int = 0;
		
		//阵型列表
		private var _zhenList:ZhenList = new ZhenList();
		
		//当前学习技能
		private var _learnSkill:int = 0;
		
		//当前学习技能 修炼程度
		private var _skillPer:int = 0;
		
		//当前学习技阵法
		private var _learnZhen:int = 0;
		
		//当前学习阵法 修炼程度
		private var _zhenPer:int = 0;
		
		//当前使用阵法
		private var _useZhen:int = 0;
		
		//当前使用阵法名称
		private var _useZhenName:String = "无阵";
		
		//所带兵种类型
		private var _soliderType:int = 0;
		
		//所带兵种名称
		private var _soliderName:String = "";
		
		//所带兵种数量
		private var _soliderNum:int = 0;
		
		//总兵力
		private var _soliderTotal:int = 0;
		
		//所带兵种士气
		private var _soliderSpirit:int = 0;
		
		//武将等级
		private var _soliderTrain:int = 0;
		
		//武将经验值
		private var _killNum:int = 0;
		
		//伤兵数目
		private var _hurtNum:int = 0;
		
		//主武器
		private var _w1Type:int = 0;
		
		//主武器等级
		private var _w1Level:int = 0;
		
		//副武器
		private var _w2Type:int = 0;
		
		//副武器等级
		private var _w2Level:int = 0;
		
		//护甲
		private var _w3Type:int = 0;
		
		//护甲等级
		private var _w3Level:int = 0;
		
		//特殊物品
		private var _w4Type:int = 0;
		
		//特殊物品等级
		private var _w4Level:int = 0;
		
		public function General()
		{
			var gameZhen:Zhen = new Zhen();
			gameZhen.uniqID = 0;
			gameZhen.zhenName = "无阵";
			_zhenList.add(gameZhen);
		}
		
		/**
		 * 武将是否学习了某个技能 
		 * @param skillID
		 * @return 
		 * 
		 */		
		public function hasSkill(uniqID:int):Boolean
		{
			var ret:Boolean = false;
			var i:int = 0;
			var skillLen:int = 0;
			var gameSkill:Skill = null;
			
			skillLen = skillList.length;
			
			for (i = 0; i < skillLen; i++)
			{
				gameSkill = skillList.getObjByIndex(i) as Skill;
				if (gameSkill != null && gameSkill.uniqID == uniqID)
				{
					ret = true;
					break;
				}
			}
			
			return ret; 
		}
		
		/**
		 * 根据武将属性是否达到技能的所需 
		 * @param uniqID
		 * @return 
		 * 
		 */		
		public function canSkill(skillID:int):Boolean
		{
			var ret:Boolean = false;
			var gameSkill:Skill = null;
			
			gameSkill = GameManager.gameMgr.skillList.getObjByID(skillID) as Skill;
			if (gameSkill == null)
				return false;
				
			if (gameSkill.uniqID <= 27)
			{
				if (kongfuCur >= gameSkill.min1 && intelligenceCur >= gameSkill.min2 && polityCur >= gameSkill.min3 )
			    	ret = true;
			}	
			else if (gameSkill.uniqID == 28)
			{
				if (kongfuCur >= gameSkill.min1 && (intelligenceCur >= gameSkill.min2 || polityCur >= gameSkill.min3))
					ret = true;
			}	
			else if (gameSkill.uniqID == 29)
			{
				if (intelligenceCur >= gameSkill.min2 && (kongfuCur >= gameSkill.min1 || polityCur >= gameSkill.min3))
					ret = true;
			}	
			else if (gameSkill.uniqID == 30)
			{
				if (polityCur >= gameSkill.min3 && (intelligenceCur >= gameSkill.min2 || kongfuCur >= gameSkill.min1))
					ret = true;
			}	
			else if (gameSkill.uniqID > 30)
			{
				if ((kongfuCur >= gameSkill.min1 && intelligenceCur >= gameSkill.max2) || (intelligenceCur >= gameSkill.min2 && polityCur >= gameSkill.max3) || (polityCur >= gameSkill.min3 && kongfuCur >= gameSkill.max1))
					ret = true;
			}	
			
			return ret;
		}
		
		/**
		 * 武将是否学习了某个阵型 
		 * @param uniqID
		 * @return 
		 * 
		 */		
		public function hasZhen(uniqID:int):Boolean
		{
			var ret:Boolean = false;
			var i:int = 0;
			var zhenLen:int = 0;
			var gameZhen:Zhen = null;
			
			zhenLen = zhenList.length;
			
			for (i = 0; i < zhenLen; i++)
			{
				gameZhen = zhenList.getObjByIndex(i) as Zhen;
				if (gameZhen != null && gameZhen.uniqID == uniqID)
				{
					ret = true;
					break;
				}
			}
			
			return ret; 
		}
		
		/**
		 * 判断武将是否能修炼某个阵型 
		 * @param uniqID
		 * @return 
		 * 
		 */		
		public function canZhen(uniqID:int):Boolean
		{
			var ret:Boolean = false;
			var gameZhen:Zhen = null;
			
			gameZhen = GameManager.gameMgr.zhenList.getObjByID(uniqID) as Zhen;
			if (gameZhen == null) return false;
			
			//锋矢  武力或政治80以上并且智力70以上
			if (gameZhen.uniqID == 5)
			{
				if (kongfuCur >= gameZhen.min1 || polityCur >= gameZhen.min3)
				    return true;
			}
			//长蛇 武力、智力或政治70以上
			else if (gameZhen.uniqID == 6)
			{
				if (kongfuCur >= gameZhen.min1|| 
				    intelligenceCur >= gameZhen.min2||
				    polityCur >= gameZhen.min3)
				    return true;
			} 
			else
			{
				if (kongfuCur >= gameZhen.min1 &&
				    intelligenceCur >= gameZhen.min2 && 
				    polityCur >= gameZhen.min3)
				    return true;
			}
			
			return ret;
		}
		
		/**
		 * 进入战斗场景后，选择兵种时对应的可以选择的阵型列表,包含正在学习的阵型 
		 * @return 
		 * 
		 */		
		public function getWarZhenListByType(typeID:int):ZhenList
		{
			var ret:ZhenList = new ZhenList();
			var gameZhen:Zhen = null;
			
			var i:int = 0;
			var zhenLen:int = 0;
			
			zhenLen = zhenList.length;
			for (i = 0; i < zhenLen; i++)
			{
				gameZhen = zhenList.getObjByIndex(i) as Zhen;
				//首先增加无阵
				if (i == 0)
				{
					ret.add(gameZhen);
					continue;
				}
				
				if (!canZhen(gameZhen.uniqID)) continue;
				if (!hasZhen(gameZhen.uniqID)) continue;
				
				//适用各种兵种
				if (gameZhen.type1ID == 0 && gameZhen.type2ID == 0)
					ret.add(gameZhen);
				else
				{
					//判断兵种是否匹配
					if (gameZhen.type1ID == typeID || gameZhen.type2ID == typeID)
						ret.add(gameZhen);
				}
			}
			
			if (learnZhen > 0)
			{
				gameZhen = GameManager.gameMgr.zhenList.getObjByID(learnZhen) as Zhen;
				
				//适用各种兵种
				if (gameZhen.type1ID == 0 && gameZhen.type2ID == 0)
					ret.add(gameZhen);
				else
				{
					//判断兵种是否匹配
					if (gameZhen.type1ID == typeID || gameZhen.type2ID == typeID)
						ret.add(gameZhen);
				}
			}
			
			return ret;
		} 
		
		/**
		 * 战斗时可变的阵型
		 * @return 
		 * 
		 */		
		public function getChangeZhenList(typeID:int, curZhenID:int):ZhenList
		{
			var ret:ZhenList = new ZhenList();
			var gameZhen:Zhen = null;
			
			var i:int = 0;
			var zhenLen:int = 0;
			
			zhenLen = zhenList.length;
			for (i = 0; i < zhenLen; i++)
			{
				gameZhen = zhenList.getObjByIndex(i) as Zhen;
				
				if (gameZhen.uniqID == curZhenID) continue;
				
				//增加无阵
				if (curZhenID != 0 && i == 0)
				{
					ret.add(gameZhen);
					continue;
				}
				
				if (!canZhen(gameZhen.uniqID)) continue;
				if (!hasZhen(gameZhen.uniqID)) continue;
				
				//适用各种兵种
				if (gameZhen.type1ID == 0 && gameZhen.type2ID == 0)
					ret.add(gameZhen);
				else
				{
					//判断兵种是否匹配
					if (gameZhen.type1ID == typeID || gameZhen.type2ID == typeID)
						ret.add(gameZhen);
				}
			}
			
			if (learnZhen > 0 && learnZhen != curZhenID)
			{
				gameZhen = GameManager.gameMgr.zhenList.getObjByID(learnZhen) as Zhen;
				
				//适用各种兵种
				if (gameZhen.type1ID == 0 && gameZhen.type2ID == 0)
					ret.add(gameZhen);
				else
				{
					//判断兵种是否匹配
					if (gameZhen.type1ID == typeID || gameZhen.type2ID == typeID)
						ret.add(gameZhen);
				}
			}
			
			return ret;
		}
		
		/**
		 * 获取兵种系对应的阵型列表 (配兵，出征界面过滤显示阵型)
		 * @return 
		 * 
		 */		
		public function getZhenBySolider():ZhenList
		{
			var ret:ZhenList = new ZhenList();
			var gameZhen:Zhen = null;
			
			var i:int = 0;
			var len:int = 0;
			
			len = zhenList.length;
			for (i = 0; i < len; i++)
			{
				gameZhen = zhenList.getObjByIndex(i) as Zhen;
				
				if (gameZhen.uniqID != 0 && !canZhen(gameZhen.uniqID)) continue;
				if (gameZhen.uniqID != 0 && !hasZhen(gameZhen.uniqID)) continue;
				
				//适用各种兵种
				if (gameZhen.type1ID == 0 && gameZhen.type2ID == 0)
					ret.add(gameZhen);
				else
				{
					//判断兵种是否匹配
					if (gameZhen.type1ID == soliderType || gameZhen.type2ID == soliderType)
						ret.add(gameZhen);
				}
			}
			
			return ret;
		}
		
		/**
		 * 获取技能的攻击加成 
		 * soliderID == 0 根据武将的装备判断兵种类型
		 * soliderID != 0 指定兵种类型(修炼时的兵种选择)
		 * @param soliderID
		 * @return 
		 * 
		 */		
		public function getAdd(soliderID:int = 0):Number
		{
			var i:int = 0;
			var len:int = 0;
			var gameSkill:Skill = null;
			var list1:SkillList = null;
			var ret:Number = 1;
			
			if (soliderID < 1)
				list1 = skillList.getListByType(soliderType);
			else
				list1 = skillList.getListByType(soliderID);
				
			len = list1.length;
			
			for (i = 0; i < len; i++)
			{
				gameSkill = list1.getObjByIndex(i) as Skill;
				if ((gameSkill.uniqID % 4) == 1)
					ret = 1.2;
				if ((gameSkill.uniqID % 4) == 2)
					ret = 1.4;
				if ((gameSkill.uniqID % 4) == 3)
					ret = 1.6;
				
				if ((gameSkill.uniqID % 4) == 0)
					ret = ret * 1.2;
			}
			
			return ret;
		}
		
		/**
		 * 获取影响兵种的技能 
		 * @return 
		 * 
		 */		
		public function getSoliderSkill():String
		{
			var i:int = 0;
			var len:int = 0;
			var gameSkill:Skill = null;
			var list1:SkillList = null;
			var ret:String = "";
			
			list1 = skillList.getListByType(soliderType);
			len = list1.length;
			
			if (len == 0)
				ret = "无";
				
			for (i = 0; i < len; i++)
			{
				gameSkill = list1.getObjByIndex(i) as Skill;
				ret += gameSkill.skillName + " ";
			}
			
			return ret;
		}
		
		/**
		 * 判断武将是否属于某势力 
		 * @param sphereID
		 * @return 
		 * 
		 */		
		public function isInSphere(sphereID:int):Boolean
		{
			var gameUser:User = GameManager.gameMgr.userList.getObjByID(userID) as User;
			if (gameUser != null && gameUser.sphereID == sphereID)
				return true;
			else
				return false;
		}
		 
		//=============================================================================================
		// 属性
		//=============================================================================================
		
		public function set uniqID(param:int):void
		{
			this._uniqID = param;
		}

		public function get uniqID():int
		{
			return this._uniqID;
		}

		public function set userID(param:int):void
		{
			this._userID = param;
		}

		public function get userID():int
		{
			return this._userID;
		}

		public function set userName(param:String):void
		{
			this._userName = param;
		}

		public function get userName():String
		{
			if (userID == 0)
				_userName = "无";
			else
			{
				var user:User = GameManager.gameMgr.userList.getObjByID(userID) as User;
				if (user != null)
					_userName = user.userName;
			}
			
			return this._userName;
		}

		public function set sphereName(param:String):void
		{
			this._sphereName = param;
		}

		public function get sphereName():String
		{
			var gameUser:User = GameManager.gameMgr.userList.getObjByID(userID) as User;
			if (gameUser != null)
				_sphereName = gameUser.sphereName; 
				
			return this._sphereName;
		}

		public function set type(param:int):void
		{
			this._type = param;
		}

		public function get type():int
		{
			return this._type;
		}

		public function set firstName(param:String):void
		{
			this._firstName = param;
		}

		public function get firstName():String
		{
			return this._firstName;
		}

		public function set lastName(param:String):void
		{
			this._lastName = param;
		}

		public function get lastName():String
		{
			return this._lastName;
		}

		public function set zi(param:String):void
		{
			this._zi = param;
		}

		public function get zi():String
		{
			return this._zi;
		}

		public function set generalName(param:String):void
		{
			this._generalName = param;
		}

		public function get generalName():String
		{
			_generalName = _firstName + _lastName;
			return this._generalName;
		}

		public function set bornYear(param:int):void
		{
			this._bornYear = param;
		}

		public function get bornYear():int
		{
			return this._bornYear;
		}

		public function set initYear(param:int):void
		{
			this._initYear = param;
		}

		public function get initYear():int
		{
			return this._initYear;
		}

		public function set initYearStr(param:String):void
		{
			this._initYearStr = param;
		}

		public function get initYearStr():String
		{
			_initYearStr = initYear.toString() + "年";
			return this._initYearStr;
		}

		public function set sex(param:int):void
		{
			this._sex = param;
		}

		public function get sex():int
		{
			return this._sex;
		}

		public function set faceID(param:int):void
		{
			this._faceID = param;
		}

		public function get faceID():int
		{
			return this._faceID;
		}

		public function set faceURL(param:String):void
		{
			this._faceURL = param;
		}

		public function get faceURL():String
		{
			var face:Face = GameManager.gameMgr.faceList.getObjByID(faceID) as Face;
			if (face != null)
				_faceURL = face.url;
				
			return this._faceURL;
		}

		public function set dieYear(param:int):void
		{
			this._dieYear = param;
		}

		public function get dieYear():int
		{
			return this._dieYear;
		}

		public function set kongfu(param:int):void
		{
			this._kongfu = param;
		}

		public function get kongfu():int
		{
			return this._kongfu;
		}

		public function set speed(param:int):void
		{
			this._speed = param;
		}

		public function get speed():int
		{
			return this._speed;
		}

		public function set polity(param:int):void
		{
			this._polity = param;
		}

		public function get polity():int
		{
			return this._polity;
		}

		public function set intelligence(param:int):void
		{
			this._intelligence = param;
		}

		public function get intelligence():int
		{
			return this._intelligence;
		}
		
		public function set faith(param:int):void
		{
			this._faith = param;
		}

		public function get faith():int
		{
			return this._faith;
		}
		
		public function set kongfuCur(param:int):void
		{
			this._kongfuCur = param;
		}

		public function get kongfuCur():int
		{
			var addValue:int = 0;
			
			if (weaponID > 0)
			{
				var userTreasure:UserTreasure = GameManager.gameMgr.userTsList.getObjByID(weaponID) as UserTreasure;
				if (userTreasure != null)
					addValue = userTreasure.treasure.propNum;
				else
					addValue = 0;
			}
			else
				addValue = 0;
			
			return this._kongfu + addValue;
		}

		public function set polityCur(param:int):void
		{
			this._polityCur = param;
		}

		public function get polityCur():int
		{
			var addValue:int = 0;
			
			if (polityBookID > 0)
			{
				var userTreasure:UserTreasure = GameManager.gameMgr.userTsList.getObjByID(polityBookID) as UserTreasure;
				if (userTreasure != null)
					addValue = userTreasure.treasure.propNum;
				else
					addValue = 0;
			}
			else
				addValue = 0;
			
			return this._polity + addValue;
		}

		public function set intelligenceCur(param:int):void
		{
			this._intelligenceCur = param;
		}

		public function get intelligenceCur():int
		{
			var addValue:int = 0;
			
			if (intellBookID > 0)
			{
				var userTreasure:UserTreasure = GameManager.gameMgr.userTsList.getObjByID(intellBookID) as UserTreasure;
				if (userTreasure != null)
					addValue = userTreasure.treasure.propNum;
				else
					addValue = 0;
			}
			else
				addValue = 0;
			
			return this._intelligence + addValue;
		}
		
		public function set faithCur(param:int):void
		{
			this._faithCur = param;
		}

		public function get faithCur():int
		{
			return this._faithCur;
		}
		
		public function set kongfuStr(param:String):void
		{
			_kongfuStr = param;
		}
		
		public function get kongfuStr():String
		{
			var addValue:int = 0;
			
			if (weaponID > 0)
			{
				var userTreasure:UserTreasure = GameManager.gameMgr.userTsList.getObjByID(weaponID) as UserTreasure;
				if (userTreasure != null)
					addValue = userTreasure.treasure.propNum;
				else
					addValue = 0;
			}
			else
				addValue = 0;
			
			if (addValue > 0)
				_kongfuStr = _kongfu.toString() + " + " + addValue.toString();
			else 
				_kongfuStr = _kongfu.toString();
				
			return _kongfuStr;
		}

		public function set polityStr(param:String):void
		{
			_polityStr = param;
		}
		
		public function get polityStr():String
		{
			var addValue:int = 0;
			
			if (polityBookID > 0)
			{
				var userTreasure:UserTreasure = GameManager.gameMgr.userTsList.getObjByID(polityBookID) as UserTreasure;
				if (userTreasure != null)
					addValue = userTreasure.treasure.propNum;
				else
					addValue = 0;
			}
			else
				addValue = 0;
			
			if (addValue > 0)
				_polityStr = _polity.toString() + " + " + addValue.toString();
			else 
				_polityStr = _polity.toString();
				
			return _polityStr;
		}

		public function set intelligenceStr(param:String):void
		{
			_intelligenceStr = param;
		}
		
		public function get intelligenceStr():String
		{
			var addValue:int = 0;
			
			if (intellBookID > 0)
			{
				var userTreasure:UserTreasure = GameManager.gameMgr.userTsList.getObjByID(intellBookID) as UserTreasure;
				if (userTreasure != null)
					addValue = userTreasure.treasure.propNum;
				else
					addValue = 0;
			}
			else
				addValue = 0;
			
			if (addValue > 0)
				_intelligenceStr = intelligence.toString() + " + " + addValue.toString();
			else 
				_intelligenceStr = intelligence.toString();
				
			return _intelligenceStr;
		}

		public function set isDead(param:int):void
		{
			this._isDead = param;
		}

		public function get isDead():int
		{
			return this._isDead;
		}

		public function set friend(param:int):void
		{
			this._friend = param;
		}

		public function get friend():int
		{
			return this._friend;
		}

		public function set follows(param:int):void
		{
			this._follows = param;
		}

		public function get follows():int
		{
			var gameWubao:WuBao = GameManager.gameMgr.wubao;
			if (gameWubao != null)
			{
				var off:Official = GameManager.gameMgr.offList.getObjByID(gameWubao.offID) as Official;
				if (off != null)
					_follows = off.follows;
			}
			
			return this._follows;
		}

		public function set weaponID(param:int):void
		{
			this._weaponID = param;
		}

		public function get weaponID():int
		{
			var treasure:UserTreasure = GameManager.gameMgr.userTsList.getByGeneral(1, uniqID);
			if (treasure != null)
				_weaponID = treasure.uniqID;
			else
				_weaponID = 0;
				
			return this._weaponID;
		}

		public function set weaponName(param:String):void
		{
			this._weaponName = param;
		}

		public function get weaponName():String
		{
			return this._weaponName;
		}

		public function set intellBookID(param:int):void
		{
			this._intellBookID = param;
		}

		public function get intellBookID():int
		{
			var treasure:UserTreasure = GameManager.gameMgr.userTsList.getByGeneral(2, uniqID);
			if (treasure != null)
				_intellBookID = treasure.uniqID;
			else
				_intellBookID = 0;
				
			return this._intellBookID;
		}

		public function set intellBookName(param:String):void
		{
			this._intellBookName = param;
		}

		public function get intellBookName():String
		{
			return this._intellBookName;
		}

		public function set polityBookID(param:int):void
		{
			this._polityBookID = param;
		}

		public function get polityBookID():int
		{
			var treasure:UserTreasure = GameManager.gameMgr.userTsList.getByGeneral(3, uniqID);
			if (treasure != null)
				_polityBookID = treasure.uniqID;
			else
				_polityBookID = 0;
				
			return this._polityBookID;
		}

		public function set polityBookName(param:String):void
		{
			this._polityBookName = param;
		}

		public function get polityBookName():String
		{
			return this._polityBookName;
		}

		public function set horseID(param:int):void
		{
			this._horseID = param;
		}

		public function get horseID():int
		{
			var treasure:UserTreasure = GameManager.gameMgr.userTsList.getByGeneral(4, uniqID);
			if (treasure != null)
				_horseID = treasure.uniqID;
			else
				_horseID = 0;
				
			return this._horseID;
		}

		public function set horseName(param:String):void
		{
			this._horseName = param;
		}

		public function get horseName():String
		{
			return this._horseName;
		}

		public function set description(param:String):void
		{
			this._description = param;
		}

		public function get description():String
		{
			if (type == 0)
				_description = GeneralDes.generalDes[0].des;
			else
				_description = GeneralDes.generalDes[uniqID].des; 
			
			return this._description;
		}
		
		public function get place():int
		{
			return this._place;
		}
		
		public function set place(param:int):void
		{
			this._place = param;
		}
		
		public function get placeID():int
		{
			return this._placeID;
		}
		
		public function set placeID(param:int):void
		{
			this._placeID = param;
		}
		
		public function get placeName():String
		{
			if (place == 1) 
				_placeName = "坞堡";
			else if (place == 2) 
			{
				var gameCity:City = GameManager.gameMgr.cityList.getObjByID(this.placeID) as City;
				
				if (gameCity) 
					_placeName = gameCity.cityName; 
				else 
					_placeName = "野城";
			}
			else if (place == 3) 
				_placeName = "军团"; 
			else if (place == 4) 
				_placeName = "路途"; 
			
			return this._placeName;
		}
		
		public function set placeName(param:String):void
		{
			this._placeName = param;
		}
		
		public function set misType(param:int):void
		{
			this._misType = param;
		}

		public function get misType():int
		{
			return this._misType;
		}
		
		public function get skill():uint
		{
			return _skill;
		}

		public function set skill(param:uint):void
		{
			if (param != _skill)
			{
				var i:int = 0;
				var skillStr:String = param.toString(2);
				if (skillStr.length < 32)
				{
					var len:int = 32 - skillStr.length;
					
					for (i = 0; i < len; i++)
					{
						skillStr = "0" + skillStr;
					}
				}
				
				skillList.removeAll();
				
				for (i = 0 ; i < skillStr.length; i++)
				{
					if (skillStr.charAt(i) == "1")
					{
						var gameSkill:Skill = GameManager.gameMgr.skillList.getObjByIndex(skillStr.length - i - 1) as Skill;
						skillList.add(gameSkill);
					}
				}
			}
			
			_skill = param;
		}

		public function get skillList():SkillList
		{
			return _skillList;
		}
		
		public function set skillList(param:SkillList):void
		{
			_skillList = param;
		}

		public function get zhen():int
		{
			return _zhen;
		}

		public function set zhen(param:int):void
		{
			if (param != _zhen)
			{
				var i:int = 0;
				var zhenStr:String = param.toString(2);
				if (zhenStr.length < 10)
				{
					var len:int = 10 - zhenStr.length;
					
					for (i = 0; i < len; i++)
					{
						zhenStr = "0" + zhenStr;
					}
				}
				
				_zhenList.removeAll();
				
				var gameZhen:Zhen = new Zhen();
				gameZhen.uniqID = 0;
				gameZhen.zhenName = "无阵";
				zhenList.add(gameZhen);
				
				for (i = 0; i < zhenStr.length; i++)
				{
					if (zhenStr.charAt(i) == "1")
					{
						var gameZhen1:Zhen = GameManager.gameMgr.zhenList.getObjByIndex(zhenStr.length - i - 1) as Zhen;
						_zhenList.add(gameZhen1);
					}
				}
			}
			
			_zhen = param;
		}
		
		public function get zhenList():ZhenList
		{
			return _zhenList;
		}
		
		public function set zhenList(param:ZhenList):void
		{
			_zhenList = param;
		}

		public function get learnSkill():int
		{
			return _learnSkill;
		}

		public function set learnSkill(value:int):void
		{
			_learnSkill = value;
		}

		public function get skillPer():int
		{
			return _skillPer;
		}

		public function set skillPer(value:int):void
		{
			_skillPer = value;
		}

		public function get learnZhen():int
		{
			return _learnZhen;
		}

		public function set learnZhen(value:int):void
		{
			_learnZhen = value;
		}

		public function get zhenPer():int
		{
			return _zhenPer;
		}

		public function set zhenPer(value:int):void
		{
			_zhenPer = value;
		}

		public function get useZhen():int
		{
			return _useZhen;
		}

		public function set useZhen(value:int):void
		{
			_useZhen = value;
		}

		public function get useZhenName():String
		{
			var gameZhen:Zhen = GameManager.gameMgr.zhenList.getObjByID(useZhen) as Zhen;
			if (gameZhen != null)
				_useZhenName = gameZhen.zhenName;
				
			return _useZhenName;
		}

		public function set useZhenName(value:String):void
		{
			_useZhenName = value;
		}

		public function get soliderType():int
		{
			_soliderType = PubUnit.getSoliderType(this);
			
			return _soliderType;
		}

		public function set soliderType(value:int):void
		{
			_soliderType = value;
		}

		public function get soliderName():String
		{
			_soliderName = PubUnit.getSoliderName(this)[0];
			
			return _soliderName;
		}

		public function set soliderName(value:String):void
		{
			_soliderName = value;
		}

		public function get soliderNum():int
		{
			return _soliderNum;
		}

		public function set soliderNum(value:int):void
		{
			_soliderNum = value;
		}

		public function get soliderTotal():int
		{
			_soliderTotal = soliderNum + hurtNum;
			
			return _soliderTotal;
		}

		public function set soliderTotal(value:int):void
		{
			_soliderTotal = value;
		}

		public function get soliderSpirit():int
		{
			return _soliderSpirit;
		}

		public function set soliderSpirit(value:int):void
		{
			_soliderSpirit = value;
		}

		public function get soliderTrain():int
		{
			return _soliderTrain;
		}

		public function set soliderTrain(value:int):void
		{
			_soliderTrain = value;
		}

		public function get killNum():int
		{
			return _killNum;
		}

		public function set killNum(value:int):void
		{
			_killNum = value;
		}
		
		public function get hurtNum():int
		{
			return _hurtNum;
		}

		public function set hurtNum(value:int):void
		{
			_hurtNum = value;
		}
		
		public function get w1Type():int
		{
			return _w1Type;
		}

		public function set w1Type(value:int):void
		{
			_w1Type = value;
		}
		
		public function get w1Level():int
		{
			return _w1Level;
		}

		public function set w1Level(value:int):void
		{
			_w1Level = value;
		}
		
		public function get w2Type():int
		{
			return _w2Type;
		}

		public function set w2Type(value:int):void
		{
			_w2Type = value;
		}
		
		public function get w2Level():int
		{
			return _w2Level;
		}

		public function set w2Level(value:int):void
		{
			_w2Level = value;
		}
		
		public function get w3Type():int
		{
			return _w3Type;
		}

		public function set w3Type(value:int):void
		{
			_w3Type = value;
		}
		
		public function get w3Level():int
		{
			return _w3Level;
		}

		public function set w3Level(value:int):void
		{
			_w3Level = value;
		}
		
		public function get w4Type():int
		{
			return _w4Type;
		}

		public function set w4Type(value:int):void
		{
			_w4Type = value;
		}
		
		public function get w4Level():int
		{
			return _w4Level;
		}

		public function set w4Level(value:int):void
		{
			_w4Level = value;
		}
		
	}
}