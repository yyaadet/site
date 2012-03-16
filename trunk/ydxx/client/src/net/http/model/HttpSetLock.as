package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpRespEvent;
	
	import utils.GameManager;
	
	public class HttpSetLock extends HttpBase
	{
		private var _quesType:int = 0;
		
		private var _ans:String = "";
		
		private var _pw:String = "";

		public function HttpSetLock()
		{
			super();
		}
		
		public function getInfo():void
		{
			httpService.url = HttpURL.SET_LOCK_PW;
			
			urlVariables.uid = GameManager.gameMgr.userID;
			urlVariables.q_type = _quesType;
			urlVariables.q_answer = _ans;
			urlVariables.password = _pw;
				
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
			var e:HttpRespEvent = new HttpRespEvent(HttpRespEvent.SET_LOCK_PW);
			e.isSuccess = isSuccess;
			e.msg = msg;
			dispatchEvent(e);
			
			removeAllEventListener();
		}
		
		public function set quesType(param:int):void
		{
			this._quesType = param;
		}

		public function get quesType():int
		{
			return this._quesType;
		}

		public function set ans(param:String):void
		{
			this._ans = param;
		}

		public function get ans():String
		{
			return this._ans;
		}

		public function set pw(param:String):void
		{
			this._pw = param;
		}

		public function get pw():String
		{
			return this._pw;
		}

	}
}