package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpRespEvent;
	
	import utils.GameManager;
	
	public class HttpTransCoin extends HttpBase
	{
		private var _oID:String = "";
		
		private var _coin:int = 0;
		
		private var _pw:String = "";

		public function HttpTransCoin()
		{
			super();
		}
		
		public function getInfo():void
		{
			httpService.url = HttpURL.TRANS_COIN;
			
			urlVariables.uid = GameManager.gameMgr.userID;
			urlVariables.other_oid = _oID;
			urlVariables.gold = _coin;
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
			var e:HttpRespEvent = new HttpRespEvent(HttpRespEvent.TRANS_COIN);
			e.isSuccess = isSuccess;
			e.msg = msg;
			dispatchEvent(e);
			
			removeAllEventListener();
		}
		
		public function set oID(param:String):void
		{
			this._oID = param;
		}

		public function get oID():String
		{
			return this._oID;
		}

		public function set coin(param:int):void
		{
			this._coin = param;
		}

		public function get coin():int
		{
			return this._coin;
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