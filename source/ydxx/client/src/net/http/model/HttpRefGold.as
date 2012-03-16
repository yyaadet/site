package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpRefEvent;
	
	public class HttpRefGold extends HttpBase
	{
		private var _userID:int = 0;
		
		public function HttpRefGold()
		{
			super();
		}
		
		public function getInfo():void
		{
			httpService.url = HttpURL.GET_REF_GOLD;
			
			//设置传递的参数
			if (_userID > 0)
				urlVariables.user_id = _userID;
				
			httpService.send(urlVariables);
		}
		
		override protected function onGetInfo(evt:ResultEvent):void
		{
			var resultXML:XML = XML(evt.result);
			var i:int = 0;
			var count:int = 0;
			var isSuccess:int = 0;
			var gold:int = 0;
			var msg:String = "";
			
			if (resultXML == "" || resultXML == null)
			{
				dispatchErrorEvent("返回的xml数据为空");
				return;
			}
			
			try
			{
				if (resultXML.hasOwnProperty("is_success"))
					isSuccess = int(resultXML.is_success);
					
				if (resultXML.hasOwnProperty("gold"))
					gold = int(resultXML.gold);
					
				if (resultXML.hasOwnProperty("msg"))
					msg = resultXML.msg;
				
			}
			catch(evt:ErrorEvent)
			{
				dispatchErrorEvent("解析xml数据有误");
				return;
			}
			
			//派发事件，通知外面信息获取成功
			var e:HttpRefEvent = new HttpRefEvent(HttpRefEvent.REF);
			e.isSuccess = isSuccess;
			e.gold = gold;
			e.msg = msg;
			dispatchEvent(e);
			
			removeAllEventListener();
		}
		
		public function set userID(param:int):void
		{
			this._userID = param;
		}

		public function get userID():int
		{
			return this._userID;
		}

	}
}