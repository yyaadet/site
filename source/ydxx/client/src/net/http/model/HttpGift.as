package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpRespEvent;
	
	public class HttpGift extends HttpBase
	{
		private var _userID:int = 0;
		
		private var _code:String = "";

		public function HttpGift()
		{
			super();
		}
		
		public function getInfo():void
		{
			httpService.url = HttpURL.GET_GIFT;
			
			//设置传递的参数
			if (_userID > 0)
				urlVariables.user_id = _userID;
			if (_code != "")
				urlVariables.code = _code;
				
			httpService.send(urlVariables);
		}
		
		override protected function onGetInfo(evt:ResultEvent):void
		{
			var resultXML:XML = XML(evt.result);
			var i:int = 0;
			var count:int = 0;
			var isSuccess:int = 0;
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
					
				if (resultXML.hasOwnProperty("msg"))
					msg = resultXML.msg;
				
			}
			catch(evt:ErrorEvent)
			{
				dispatchErrorEvent("解析xml数据有误");
				return;
			}
			
			//派发事件，通知外面信息获取成功
			var e:HttpRespEvent = new HttpRespEvent(HttpRespEvent.GIFT);
			e.isSuccess = isSuccess;
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

		public function set code(param:String):void
		{
			this._code = param;
		}

		public function get code():String
		{
			return this._code;
		}

	}
}