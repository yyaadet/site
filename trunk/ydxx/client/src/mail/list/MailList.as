package mail.list
{
	import mail.model.Mail;
	
	import utils.list.GameList;

	/**
	 * 邮件列表 
	 * @author bxl
	 * 
	 */	
	public class MailList extends GameList
	{
		public function MailList()
		{
			super();
		}
		
		/**
		 * 根据类型获取邮件列表 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getListByType(type:int):MailList
		{
			var i:int = 0;
			var gameMail:Mail = null;
			var ary1:Array = [];
			var len:int = 0;
			var ret:MailList = new MailList();
			
			ary1 = this.list.sortOn("sendTime", Array.DESCENDING | Array.NUMERIC);
			len = ary1.length;
			
			for (i = 0; i < len; i++)
			{
				gameMail = ary1[i] as Mail;
				if (gameMail != null && gameMail.type == type)
					ret.add(gameMail);
			}
			
			return ret;
		}
		
		/**
		 * 获取未读邮件列表 
		 * @return 
		 * 
		 */		
		public function getNoReadMail():MailList
		{
			var i:int = 0;
			var gameMail:Mail = null;
			var len:int = 0;
			var ret:MailList = new MailList();
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				gameMail = getObjByIndex(i) as Mail;
				if (gameMail != null && (gameMail.type == 0 || gameMail.type == 3) && !gameMail.isRead)
					ret.add(gameMail);
			}
			
			return ret;
		}
		
		/**
		 * 设置所有的邮件未默认的未选中状态 
		 * 
		 */		
		public function setDefault():void
		{
			var i:int = 0;
			var gameMail:Mail = null;
			
			for (i = 0; i < this.length; i++)
			{
				gameMail = getObjByIndex(i) as Mail;
				if (gameMail != null)
					gameMail.isSel = false;
			}
		}
		
		/**
		 * 设置邮件为已读状态 
		 * @param mailID
		 * 
		 */		
		public function setRead(mailID:int):void
		{
			var i:int = 0;
			var gameMail:Mail = null;
			
			for (i = 0; i < this.length; i++)
			{
				gameMail = getObjByIndex(i) as Mail;
				if (gameMail != null && gameMail.uniqID == mailID)
					gameMail.isRead = 1;
			}
		}
		
	}
}