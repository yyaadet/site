package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpSucEvent;
	
	import utils.GameManager;
	
	import wubao.list.FaceList;
	import wubao.model.Face;
	
	/**
	 * Http获取头像信息 
	 * @author StarX
	 * 
	 */	
	public class HttpFace extends HttpBase
	{
		//头像信息
		private var faceList:FaceList = null;
		
		public function HttpFace()
		{
			super();
		}
		
		public function getInfo():void
		{
			//获取所有武将头像
			faceList = new FaceList();
			httpService.url = HttpURL.GET_FACE;
				
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
				if (resultXML.hasOwnProperty("face"))
				{
					count = resultXML.child("face").length();
					
					if (count < 1)
					{
						dispatchErrorEvent("头像数目为0");
						return;
					}
				}
				
				//将返回的xml数据放入faceList数组中
				var node:XMLList = resultXML.face;
				
				for(i = 0; i < count; i++)
				{
					var face:Face = new Face();
					var nodeXML:XML = node[i];
					
					if (resultXML.face[i].hasOwnProperty("id"))
						face.uniqID = int(nodeXML.id);
						
					if (nodeXML.hasOwnProperty("sex"))
						face.sex = int(nodeXML.sex);
						
					if (nodeXML.hasOwnProperty("url"))
						face.url = GameManager.gameMgr.resURL + "general/" + nodeXML.url;
					
					faceList.add(face);
				}
				
				GameManager.gameMgr.faceList = faceList;
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