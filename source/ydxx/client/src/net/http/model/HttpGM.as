package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpSucEvent;
	
	import utils.GameManager;
	
	import wubao.model.User;
	
	/**
	 * Http获取关卡信息 
	 * @author StarX
	 * 
	 */	
	public class HttpGM extends HttpBase
	{
		public function HttpGM()
		{
			super();
		}
		
		public function getInfo():void
		{
			httpService.url = HttpURL.GET_GM;
				
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
				//判断xml文件是否存在节点 "gm"
				if (resultXML.hasOwnProperty("gm"))
				{
					count = resultXML.child("gm").length();
					
					if (count < 1)
					{
						dispatchErrorEvent("gm数目为0");
						return;
					}
				}
				
				//将返回的xml数据放入数组中
				var node:XMLList = resultXML.gm;
				
				for(i = 0; i < count; i++)
				{
					var userID:int = 0;
					var gameUser:User = null;
					var nodeXML:XML = node[i];
					
					if (nodeXML.hasOwnProperty("id"))
						userID = int(nodeXML.id);
					
					gameUser = GameManager.gameMgr.userList.getObjByID(userID) as User;
					if (gameUser != null)
						gameUser.isGM = true;
				}
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