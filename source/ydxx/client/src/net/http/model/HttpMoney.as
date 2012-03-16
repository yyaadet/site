package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpSucEvent;
	
	import utils.GameManager;
	
	/**
	 * Http获取金钱信息 
	 * @author StarX
	 * 
	 */	
	public class HttpMoney extends HttpBase
	{
		public function HttpMoney()
		{
			super();
		}
		
		public function getInfo():void
		{
			httpService.url = HttpURL.GET_MONEY;
			urlVariables.uid = GameManager.gameMgr.userID;
			
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
				var num:int = 0;
				var gold:int = 0;
				
				if (resultXML.hasOwnProperty("num"))
					num = int(resultXML.num);
					
				if (resultXML.hasOwnProperty("gold"))
					gold = int(resultXML.gold);
					
				GameManager.gameMgr.user.chong = num;
				 GameManager.gameMgr.user.give = gold;
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