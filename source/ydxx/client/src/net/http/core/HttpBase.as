package net.http.core
{
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import net.http.events.HttpErrEvent;
	
	import utils.GameManager;
	
	/**
	 * http访问API基础类 
	 * @author StarX
	 * 
	 */	
	public class HttpBase extends EventDispatcher
	{
		//httpService的web访问路径
		private var _url:String = "";
		
		//访问web api所需要的类
		protected var httpService:HTTPService = null;
		protected var urlVariables:URLVariables = null;
		
		public function HttpBase()
		{
			super();
			
			if (httpService == null)
			{
				httpService = new HTTPService();
				
				//设定httpservice的返回格式位xml格式
				httpService.resultFormat = HTTPService.RESULT_FORMAT_XML;
				
				//设定httpservice的超时秒数
				httpService.requestTimeout = 60;
			}
			
			if (urlVariables == null)
				urlVariables = new URLVariables(); 
			
			urlVariables.hash_id = GameManager.gameMgr.hashID;
			urlVariables.date = new Date().getTime();
				
			addAllEventListener();
		}
		
		private function addAllEventListener():void
		{
			if (httpService != null)
			{
				httpService.addEventListener(ResultEvent.RESULT, onGetInfo);
				httpService.addEventListener(FaultEvent.FAULT, onError);
			}
		}
		
		protected function removeAllEventListener():void
		{
			if (httpService != null)
			{
				httpService.removeEventListener(ResultEvent.RESULT, onGetInfo);
				httpService.removeEventListener(FaultEvent.FAULT, onError);
			}
		}
		
		protected function onGetInfo(evt:ResultEvent):void
		{
			//具体过程由子类实现
		}
		
		protected function onError(evt:FaultEvent):void
		{
			dispatchErrorEvent("获取xml数据失败");
			removeAllEventListener();
		}
		
		/**
		 * 派发http请求错误事件
		 * @param errorInfo 错误信息
		 * 
		 */		
		protected function dispatchErrorEvent(errorInfo:String):void
		{
			var httpError:HttpErrEvent = new HttpErrEvent(HttpErrEvent.ERROR);
			
			httpError.errorInfo = errorInfo;
			dispatchEvent(httpError);
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(param:String):void
		{
			_url = param;
		}
		
	}
}