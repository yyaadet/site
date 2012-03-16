	// 游戏入口代码文件
	
	import army.list.ArmyList;
	
	import battle.list.BattleList;
	import battle.list.GateGeneralList;
	import battle.list.GatewayList;
	
	import city.list.AttackCityList;
	import city.list.CityList;
	
	import deal.list.BillList;
	import deal.list.SellList;
	
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.system.Security;
	
	import general.list.GeneralList;
	import general.list.SkillList;
	import general.list.ZhenList;
	import general.model.Skill;
	import general.model.Zhen;
	
	import guid.GuidManager;
	
	import images.AssetsManager;
	
	import map.MapManager;
	
	import mx.core.Application;
	import mx.core.ScrollPolicy;
	import mx.utils.StringUtil;
	
	import net.http.HttpManager;
	import net.tcp.TcpManager;
	import net.tcp.events.TcpErrEvent;
	import net.tcp.events.TcpSucEvent;
	
	import sphere.list.DipList;
	import sphere.list.SphLevList;
	import sphere.list.SphereList;
	import sphere.model.SphLevel;
	
	import utils.GameManager;
	import utils.PubUnit;
	import utils.SceneManager;
	import utils.WinManager;
	
	import wubao.list.Dignlist;
	import wubao.list.FriendList;
	import wubao.list.OfficialList;
	import wubao.list.TranList;
	import wubao.list.UserList;
	import wubao.list.UserTsList;
	import wubao.model.Dignitie;
	import wubao.model.Official;
	import wubao.model.WuBao;
	
	//从本地的so文件中读取信息
	private var so1:SharedObject = null;
	private var resURL:String = "";
	private var exchangeURL:String = "";
	private var gotoURL:String = "";
	private var hashID:String = "";
	private var userID:int = 0;
	private var socketIP:String = "";
	private var socketPort:int = 0;
	private var securityIP:String = "";
	private var securityPort:int = 0;
	
	/**
	 * 游戏初始化 
	 * 
	 */	
	private function initApp():void
	{
		this.horizontalScrollPolicy = ScrollPolicy.OFF;
		this.verticalScrollPolicy = ScrollPolicy.OFF;
		
		try
		{
			var param:Object = Application.application.parameters;
			hashID = param.hash_id;
			userID = int(param.uid);
			socketIP = param.socket_ip;
			socketPort = int(param.socket_port);
			securityIP = param.flex_ip;
			securityPort = int(param.flex_port);
			resURL = param.res_url;
			exchangeURL = param.convert_money;
			gotoURL = param.redirect_url;
		}
		catch(e:Error)
		{
			
		}
		
		//测试
		hashID = "b697e3328c03fbe6a331ba7c9af0422d";
		userID = 23;
		socketIP = "192.168.36.12";
		socketPort = 4010;
		securityIP = "192.168.36.12";
		securityPort = 4011;
		resURL = "http://192.168.36.12:8080";
		
		//公网
//		hashID = "c626e6fec668d4fabf4b2da1548965b9";
//		userID = 331;
//		socketIP = "211.157.108.248";
//		socketPort = 8610;
//		securityIP = "211.157.108.248";
//		securityPort = 8611;
//		resURL = "http://ydxxres1.51zhi.com";
		
		if (StringUtil.trim(resURL) != "")
		{
			var str:String = resURL.substr(resURL.length - 1, 1);
			if (str == "/")
				resURL = resURL;
			else
				resURL = resURL + "/";
		} 
		
		Security.loadPolicyFile(resURL + "crossdomain.xml");
		
		//初始化游戏中的所有的管理器
		TcpManager.init(socketIP, socketPort, securityIP, securityPort);
		AssetsManager.init();
		GameManager.init();
		HttpManager.init();
		WinManager.init();
		MapManager.init();
		SceneManager.init();
		GuidManager.init();
		
		//初始化游戏类
		var userList:UserList = new UserList();
		GameManager.gameMgr.userList = userList;
		
		var gameWubao:WuBao = new WuBao();
		GameManager.gameMgr.wubao = gameWubao;
		
		var cityList:CityList = new CityList();
		GameManager.gameMgr.cityList = cityList;
		
		var armyList:ArmyList = new ArmyList();
		GameManager.gameMgr.armyList = armyList;
		
		var sphereList:SphereList = new SphereList();
		GameManager.gameMgr.sphereList = sphereList;
		
		var generalList:GeneralList = new GeneralList();
		GameManager.gameMgr.generalList = generalList;
		
		var userTsList:UserTsList = new UserTsList();
		GameManager.gameMgr.userTsList = userTsList;
		
		var dipList:DipList = new DipList()
		GameManager.gameMgr.dipList = dipList;
		
		var friendList:FriendList = new FriendList()
		GameManager.gameMgr.friendList = friendList;
		
		var tranList:TranList = new TranList()
		GameManager.gameMgr.tranList = tranList;
		
		var billList:BillList = new BillList()
		GameManager.gameMgr.billList = billList;
		
		var sellList:SellList = new SellList()
		GameManager.gameMgr.sellList = sellList;
		
		var battleList:BattleList = new BattleList();
		GameManager.gameMgr.battleList = battleList;
		
		var gatewayList:GatewayList = new GatewayList();
		GameManager.gameMgr.gateList = gatewayList;
		
		var gateGeneralList:GateGeneralList = new GateGeneralList();
		GameManager.gameMgr.gateGeneralList = gateGeneralList;
		
		var atkCityList:AttackCityList = new AttackCityList();
		GameManager.gameMgr.atkCityList = atkCityList;
		
		initSKill();
		initZhen();
		initDig();
		initSphereLevel();
		initOfficial();
		
		GameManager.gameMgr.gameApp = this;
		GameManager.gameMgr.hashID = hashID;
		GameManager.gameMgr.userID = userID;
		GameManager.gameMgr.resURL = resURL;
		GameManager.gameMgr.gotoURL = gotoURL;
		GameManager.gameMgr.exchangeURL = exchangeURL;
		SceneManager.sceneMgr.sceneWubao = swb;
		SceneManager.sceneMgr.sceneMap = smp;
		SceneManager.sceneMgr.sceneFight = sf;
		SceneManager.sceneMgr.sceneArea = sa;
		SceneManager.sceneMgr.sceneAttackCity = sac;
		SceneManager.sceneMgr.sceneBattle = sb;
		WinManager.winMgr.showMainLoad();
		
		panelRes.visible = false;
		panelRes.includeInLayout = false;
		bigMap.visible = false;
		bigMap.includeInLayout = false;
		panelDate.visible = false;
		panelDate.includeInLayout = false;
		swb.visible = false;
		swb.includeInLayout = false;
		panelMenu.visible = false;
		panelMenu.includeInLayout = false;
		panelOperate.visible = false;
		panelOperate.includeInLayout = false;
		panelPlace.visible = false;
		panelPlace.includeInLayout = false;
		panelAlarm.visible = false;
		panelAlarm.includeInLayout = false;
		panelQuene.visible = false;
		panelQuene.includeInLayout = false;
		panelTip.visible = false;
		panelTip.includeInLayout = false;
		panelAttackCity.visible = false;
		panelAttackCity.includeInLayout = false;
		
		writeHashIDSO();
		
		connectServer();
	}
	
	private function initSKill():void
	{
		var i:int = 0;
		var obj:Object;
		var gameSkill:Skill = null;
		var skillList:SkillList = new SkillList();
		
		for (i = 0; i < PubUnit.skillList.length; i++)
		{
			obj = PubUnit.skillList[i];
			gameSkill = new Skill();
			gameSkill.uniqID = obj.id;
			gameSkill.skillName = obj.name;
			gameSkill.skillType = obj.skill_type;
			gameSkill.typeID = obj.type;
			gameSkill.typeName = obj.type_name;
			gameSkill.min1 = obj.min1;
			gameSkill.max1 = obj.max1;
			gameSkill.min2 = obj.min2;
			gameSkill.max2 = obj.max2;
			gameSkill.min3 = obj.min3;
			gameSkill.max3 = obj.max3;
			gameSkill.pre = obj.pre;
			gameSkill.condi = obj.condi;
			gameSkill.info = obj.info;
			skillList.add(gameSkill);
		}
		
		GameManager.gameMgr.skillList = skillList;
	}
			
	private function initZhen():void
	{
		var i:int = 0;
		var obj:Object;
		var gameZhen:Zhen = null;
		var zhenList:ZhenList = new ZhenList();
		
		for (i = 0; i < PubUnit.zhenList.length; i++)
		{
			obj = PubUnit.zhenList[i];
			gameZhen = new Zhen();
			gameZhen.uniqID = obj.id;
			gameZhen.zhenName = obj.name;
			gameZhen.type1ID = obj.type1;
			gameZhen.type2ID = obj.type2;
			gameZhen.attack = obj.attack;
			gameZhen.defense = obj.defense;
			gameZhen.speed = obj.speed;
			gameZhen.min1 = obj.min1;
			gameZhen.max1 = obj.max1;
			gameZhen.min2 = obj.min2;
			gameZhen.max2 = obj.max2;
			gameZhen.min3 = obj.min3;
			gameZhen.max3 = obj.max3;
			gameZhen.pre = obj.pre;
			gameZhen.condi = obj.condi;
			gameZhen.info = obj.info;
			zhenList.add(gameZhen);
		}
		
		GameManager.gameMgr.zhenList = zhenList;
	}
	
	private function initDig():void
	{
		var i:int = 0;
		var obj:Object;
		var digLen:int = 0;
		var digList:Dignlist = new Dignlist();
		
		digLen = PubUnit.dignitieList.length;
		for(i = digLen - 1; i >= 0; i--)
		{
			obj = PubUnit.dignitieList[i];
			var dig:Dignitie = new Dignitie();
			dig.uniqID = obj.id;
			dig.digName = obj.name;
			dig.prestige = obj.prestige;
			dig.generalMax = obj.general_num;
			
			digList.add(dig);
		}
		
		GameManager.gameMgr.digList = digList;
	}
	
	private function initSphereLevel():void
	{
		var i:int = 0;
		var obj:Object;
		var slLen:int = 0;
		var slList:SphLevList = new SphLevList();
		
		slLen = PubUnit.sphLevelList.length;
		for(i = slLen - 1; i >= 0; i--)
		{
			obj = PubUnit.sphLevelList[i];
			var sphLevel:SphLevel = new SphLevel();
			sphLevel.uniqID = obj.id;
			sphLevel.levName = obj.name;
			sphLevel.userNum = obj.user_num;
			sphLevel.cityNum = obj.city_num;
			
			slList.add(sphLevel);
		}
		
		GameManager.gameMgr.slList = slList;
	}
	
	private function initOfficial():void
	{
		var i:int = 0;
		var obj:Object;
		var offLen:int = 0;
		var offList:OfficialList = new OfficialList();
		
		offLen = PubUnit.officialList.length;
		for(i = offLen - 1; i >= 0; i--)
		{
			obj = PubUnit.officialList[i];
			var official:Official = new Official();
			official.uniqID = obj.id;
			official.offName = obj.name;
			official.levelID = obj.level;
			official.type = obj.type;
			official.typeName = official.type == 0 ? "武职" : "文职";
			official.follows = obj.follows;
			official.kongfu = obj.kongfu;
			official.speed = obj.speed;
			official.polity = obj.polity;
			official.intelligence = obj.intelligence;
			official.salary = obj.salary;
			official.dig = obj.dig;
			
			offList.add(official);
		}
		
		GameManager.gameMgr.offList = offList;
	}
	
	private function writeHashIDSO():void
	{
		var so2:SharedObject = SharedObject.getLocal("duokai");
		if (so2 != null)
		{
			so2.data.hashID = hashID;
			try
			{
				so2.flush();
				so2.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			}
			catch(e:Error)
			{
				trace(e.toString());
			}
			
			
		}
	}
			
	private function netStatus(evt:NetStatusEvent):void
	{
		
	}
	
	/**
	 * 连接Tcp服务器 
	 * 
	 */	
	private function connectServer():void
	{
		TcpManager.tcpMgr.addEventListener(TcpSucEvent.SUCCESS, tcpSuccess);
		TcpManager.tcpMgr.addEventListener(TcpErrEvent.ERROR, tcpError);
		TcpManager.tcpMgr.connect();
	}
	
	/**
	 * Tcp连接成功 
	 * @param evt
	 * 
	 */	
	private function tcpSuccess(evt:TcpSucEvent):void
	{
		TcpManager.tcpMgr.removeEventListener(TcpSucEvent.SUCCESS, tcpSuccess);
		TcpManager.tcpMgr.removeEventListener(TcpErrEvent.ERROR, tcpError);
	}
	
	/**
	 * Tcp连接失败 
	 * @param evt
	 * 
	 */	
	private function tcpError(evt:TcpErrEvent):void
	{
		WinManager.winMgr.showResult("连接服务器失败，请刷新页面重试");
		TcpManager.tcpMgr.removeEventListener(TcpSucEvent.SUCCESS, tcpSuccess);
		TcpManager.tcpMgr.removeEventListener(TcpErrEvent.ERROR, tcpError);
	}
	
	/**
	 * 初始化用户界面 
	 * 
	 */	
	public function showUI():void
	{
		panelDate.visible = true;
		panelDate.includeInLayout = true;
		panelMenu.visible = true;
		panelMenu.includeInLayout = true;
		panelRes.visible = true;
		panelRes.includeInLayout = true;
		panelOperate.visible = true;
		panelOperate.includeInLayout = true;
		panelQuene.visible = true;
		panelQuene.includeInLayout = true;
		panelTip.visible = true;
		panelTip.includeInLayout = true;
		chatMain.visible = true;
		chatMain.includeInLayout = true;
		panelAttackCity.visible = true;
		panelAttackCity.includeInLayout = true;
	}
	
	private function openChat():void
	{
		chatOpen.visible = false;
		chatOpen.includeInLayout = false;
		chatMain.visible = true;
		chatMain.includeInLayout = true;
	}
			
	
	
