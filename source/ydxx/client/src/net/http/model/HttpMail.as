package net.http.model
{
	import flash.events.ErrorEvent;
	
	import mail.list.MailList;
	import mail.model.Mail;
	
	import mx.rpc.events.ResultEvent;
	
	import net.http.HttpURL;
	import net.http.core.HttpBase;
	import net.http.events.HttpSucEvent;
	
	import utils.GameManager;
	
	/**
	 * Http获取邮件信息 
	 * @author StarX
	 * 
	 */	
	public class HttpMail extends HttpBase
	{
		//定义道具信息列表类
		private var mailList:MailList = new MailList();
		
		public function HttpMail()
		{
			super();
		}
		
		public function getInfo():void
		{
			//设置httpService的web访问路径
			httpService.url = HttpURL.GET_MAIL;
			urlVariables.uid = GameManager.gameMgr.userID;
			urlVariables.now = GameManager.gameMgr.gameTime;
			
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
				if (resultXML.hasOwnProperty("mail"))
				{
					count = resultXML.child("mail").length();
					
					if (count < 1)
					{
						return;
					}
				}
				
				for(i = 0; i < count; i++)
				{
					var gameMail:Mail = new Mail();
					
					if (resultXML.mail[i].hasOwnProperty("id"))
						gameMail.uniqID = int(resultXML.mail[i].id);
						
					if (resultXML.mail[i].hasOwnProperty("sender_id"))
						gameMail.senderID = int(resultXML.mail[i].sender_id);
						
					if (resultXML.mail[i].hasOwnProperty("sender_name"))
						gameMail.senderName = resultXML.mail[i].sender_name;
						
					if (resultXML.mail[i].hasOwnProperty("receive_id"))
						gameMail.receiveID = int(resultXML.mail[i].receive_id);
						
					if (resultXML.mail[i].hasOwnProperty("receive_name"))
						gameMail.receiveName = resultXML.mail[i].receive_name;
						
					if (resultXML.mail[i].hasOwnProperty("title"))
						gameMail.title = resultXML.mail[i].title;
						
					if (resultXML.mail[i].hasOwnProperty("content"))
						gameMail.content = resultXML.mail[i].content;
						
					if (resultXML.mail[i].hasOwnProperty("is_read"))
						gameMail.isRead = int(resultXML.mail[i].is_read);
						
					if (resultXML.mail[i].hasOwnProperty("type"))
						gameMail.type = int(resultXML.mail[i].type);
						
					if (resultXML.mail[i].hasOwnProperty("send_time"))
						gameMail.sendTime = int(resultXML.mail[i].send_time);
						
					mailList.add(gameMail);
				}
				
				GameManager.gameMgr.mailList = mailList;
				
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
		
		public function readMail(mailID:int):void
		{
			removeAllEventListener();
			
			//设置httpService的web访问路径
			httpService.url = HttpURL.READ_MAIL;
			urlVariables.uid = GameManager.gameMgr.userID;
			urlVariables.mail_id = mailID;
			
			//发送请求 
			httpService.send(urlVariables);
		}

		public function delMail(mailID:int):void
		{
			removeAllEventListener();
			
			//设置httpService的web访问路径
			httpService.url = HttpURL.DEL_MAIL;
			urlVariables.uid = GameManager.gameMgr.userID;
			urlVariables.mail_id = mailID;
			
			//发送请求 
			httpService.send(urlVariables);
		}

	}
}