package net.http.model
{
	import fight.list.PassList;
	import fight.model.Pass;
	
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpSucEvent;
	
	import utils.GameManager;
	
	/**
	 * Http获取打擂关卡信息 
	 * @author StarX
	 * 
	 */	
	public class HttpPass extends HttpBase
	{
		//关卡信息
		private var passList:PassList = new PassList();
		
		public function HttpPass()
		{
			super();
		}
		
		public function getInfo():void
		{
			httpService.url = HttpURL.GET_PASS;
				
			httpService.send(urlVariables);
		}
		
		override protected function onGetInfo(evt:ResultEvent):void
		{
			var resultXML:XML = XML(evt.result);
			var i:int = 0;
			var count:int = 0;
			
			if (resultXML == "" || resultXML == null)
			{
				dispatchErrorEvent("返回的xml数据为空");
				return;
			}
			
			try
			{
				//判断xml文件是否存在节点 "face"
				if (resultXML.hasOwnProperty("pk"))
				{
					count = resultXML.child("pk").length();
					
					if (count < 1)
					{
						dispatchErrorEvent("关卡数目为0");
						return;
					}
				}
				
				//将返回的xml数据放入数组中
				var node:XMLList = resultXML.pk;
				
				for(i = 0; i < count; i++)
				{
					var pass:Pass = new Pass();
					var nodeXML:XML = node[i];
					
					if (nodeXML.hasOwnProperty("id"))
						pass.uniqID = int(nodeXML.id);
						
					if (nodeXML.hasOwnProperty("level"))
						pass.level = int(nodeXML.level);
						
					if (nodeXML.hasOwnProperty("name"))
					{
						var generalName:String = nodeXML.name;
						pass.general.firstName = generalName.substr(0, 1);
						pass.general.lastName = generalName.substr(1, generalName.length);
					}
						
					if (nodeXML.hasOwnProperty("face_id"))
						pass.general.faceID = int(nodeXML.face_id);
						
					if (nodeXML.hasOwnProperty("skill"))
						pass.general.skill = int(nodeXML.skill);
						
					if (nodeXML.hasOwnProperty("zhen"))
						pass.general.useZhen = int(nodeXML.zhen);
						
					if (nodeXML.hasOwnProperty("kongfu"))
						pass.general.kongfu = int(nodeXML.kongfu);
						
					if (nodeXML.hasOwnProperty("intelligence"))
						pass.general.intelligence = int(nodeXML.intelligence);
						
					if (nodeXML.hasOwnProperty("polity"))
						pass.general.polity = int(nodeXML.polity);
						
					if (nodeXML.hasOwnProperty("w1_type"))
						pass.general.w1Type = int(nodeXML.w1_type);
						
					if (nodeXML.hasOwnProperty("w1_level"))
						pass.general.w1Level = int(nodeXML.w1_level);
						
					if (nodeXML.hasOwnProperty("w2_type"))
						pass.general.w2Type = int(nodeXML.w2_type);
						
					if (nodeXML.hasOwnProperty("w2_level"))
						pass.general.w2Level = int(nodeXML.w2_level);
						
					if (nodeXML.hasOwnProperty("w3_type"))
						pass.general.w3Type = int(nodeXML.w3_type);
						
					if (nodeXML.hasOwnProperty("w3_level"))
						pass.general.w3Level = int(nodeXML.w3_level);
						
					if (nodeXML.hasOwnProperty("w4_type"))
						pass.general.w4Type = int(nodeXML.w4_type);
						
					if (nodeXML.hasOwnProperty("w4_level"))
						pass.general.w4Level = int(nodeXML.w4_level);
						
					if (nodeXML.hasOwnProperty("solider"))
					{
						pass.general.soliderNum = int(nodeXML.solider);
						pass.general.soliderTotal = int(nodeXML.solider);
					}
						
					if (nodeXML.hasOwnProperty("train"))
						pass.general.soliderTrain = int(nodeXML.train);
						
					if (nodeXML.hasOwnProperty("spirit"))
						pass.general.soliderSpirit = int(nodeXML.spirit);
						
					if (nodeXML.hasOwnProperty("prestige"))
						pass.prestige = int(nodeXML.prestige);
						
					if (nodeXML.hasOwnProperty("gold"))
						pass.gold = int(nodeXML.gold);
						
					if (nodeXML.hasOwnProperty("cd"))
						pass.cd = int(nodeXML.cd);
						
					passList.add(pass);
				}
				
				GameManager.gameMgr.passList = passList;
			}
			catch(evt:ErrorEvent)
			{
				dispatchErrorEvent("解析xml数据有误");
				return;
			}
			
			//派发头像列表事件，通知外面信息获取成功
			var e:HttpSucEvent = new HttpSucEvent(HttpSucEvent.SUCCESS);
			dispatchEvent(e);
			
			removeAllEventListener();
		}
		
	}
}