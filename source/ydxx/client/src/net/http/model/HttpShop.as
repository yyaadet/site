package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpSucEvent;
	
	import shop.list.TreasureList;
	import shop.model.Treasure;
	
	import utils.GameManager;
	
	/**
	 * Http获取道具信息 
	 * @author StarX
	 * 
	 */	
	public class HttpShop extends HttpBase
	{
		//定义道具信息列表类
		private var treasureList:TreasureList = new TreasureList();
		
		public function HttpShop()
		{
			super();
		}
		
		public function getInfo():void
		{
			//设置httpService的web访问路径
			httpService.url = HttpURL.GET_SHOP;
			
			//发送请求 
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
				//判断xml文件是否存在节点 "treasure"
				if (resultXML.hasOwnProperty("shop"))
				{
					count = resultXML.child("shop").length();
					
					if (count < 1)
					{
						dispatchErrorEvent("道具数目为0");
						return;
					}
				}
				
				//将返回的xml数据放入gameTreasureList数组中
				for(i = 0; i < count; i++)
				{
					var gameTreasure:Treasure = new Treasure();
					
					if (resultXML.shop[i].hasOwnProperty("id"))
						gameTreasure.uniqID = int(resultXML.shop[i].id);
						
					if (resultXML.shop[i].hasOwnProperty("name"))
						gameTreasure.name = resultXML.shop[i].name;
						
					if (resultXML.shop[i].hasOwnProperty("big_url"))
						gameTreasure.bigUrl = GameManager.gameMgr.resURL + "treasure/" + resultXML.shop[i].big_url;
						
					if (resultXML.shop[i].hasOwnProperty("url"))
						gameTreasure.url = GameManager.gameMgr.resURL + "treasure/" + resultXML.shop[i].url;
						
					if (resultXML.shop[i].hasOwnProperty("type"))
						gameTreasure.type = int(resultXML.shop[i].type);
						
					if (resultXML.shop[i].hasOwnProperty("level"))
						gameTreasure.level= int(resultXML.shop[i].level);
						
					if (resultXML.shop[i].hasOwnProperty("num"))
						gameTreasure.propNum = int(resultXML.shop[i].num);
						
					if (resultXML.shop[i].hasOwnProperty("coins"))
						gameTreasure.price = int(resultXML.shop[i].coins);
						
					if (resultXML.shop[i].hasOwnProperty("description"))
						gameTreasure.description = resultXML.shop[i].description;
						
					treasureList.add(gameTreasure);
				}
				
				GameManager.gameMgr.treasureList = treasureList;
				
			}
			catch(evt:ErrorEvent)
			{
				dispatchErrorEvent("解析xml数据有误");
				return;
			}
			
			//派发道具列表事件，通知外面信息获取成功
			var e:HttpSucEvent = new HttpSucEvent(HttpSucEvent.SUCCESS);
			dispatchEvent(e);
			
			removeAllEventListener();
		}

	}
}