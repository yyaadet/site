package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpRespEvent;
	
	import utils.GameManager;
	
	public class HttpModiLock extends HttpBase
	{
		private var _oldPW:String = "";
		
		private var _newPW:String = "";

		public function HttpModiLock()
		{
			super();
		}
		
		public function getInfo():void
		{
			httpService.url = HttpURL.MODI_LOCK_PW;
			
			urlVariables.uid = GameManager.gameMgr.userID;
			urlVariables.old_password = _oldPW;
			urlVariables.new_password = _newPW;
				
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
			var e:HttpRespEvent = new HttpRespEvent(HttpRespEvent.MODI_LOCK_PW);
			e.isSuccess = isSuccess;
			e.msg = msg;
			dispatchEvent(e);
			
			removeAllEventListener();
		}
		
		public function set oldPW(param:String):void
		{
			this._oldPW = param;
		}

		public function get oldPW():String
		{
			return this._oldPW;
		}

		public function set newPW(param:String):void
		{
			this._newPW = param;
		}

		public function get newPW():String
		{
			return this._newPW;
		}

	}
}