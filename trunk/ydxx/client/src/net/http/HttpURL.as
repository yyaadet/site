package net.http
{
	/**
	 * web API URL地址类 
	 * @author StarX
	 * 
	 */	
	public class HttpURL
	{
		//测试用
		public static const urlPre:String = "http://192.168.36.12:7000";
		
		//public static const urlPre:String = "http://ydxx1.51zhi.com";
		
		//public static const urlPre:String = "";
		
		//获取头像列表
		public static const GET_FACE:String = urlPre + "/home/face";

		//获取道具列表
		public static const GET_SHOP:String = urlPre + "/home/shop";

		//获取用户金币数
		public static const GET_MONEY:String = urlPre + "/home/money";
		
		//获取任务
		public static const GET_TASK:String = urlPre + "/home/task";
		
		//获取邮件
		public static const GET_MAIL:String = urlPre + "/home/mail";
		
		//读取邮件
		public static const READ_MAIL:String = urlPre + "/home/read_mail";
		
		//删除邮件
		public static const DEL_MAIL:String = urlPre + "/home/del_mail";
		
		//获取礼品
		public static const GET_GIFT:String = urlPre + "/home/use_game_gift";
		
		//获取推广奖励
		public static const GET_REF_GOLD:String = urlPre + "/home/get_ref_gold";
		
		//获取GM列表
		public static const GET_GM:String = urlPre + "/home/gm";
		
		//获取敏感词
		public static const GET_FILTER:String = urlPre + "/home/filters";
		
		//获取金币锁信息
		public static const GET_LOCK_INFO:String = urlPre + "/home/get_pay_info";
		
		//设置金币锁密码
		public static const SET_LOCK_PW:String = urlPre + "/home/set_pay_password";
		
		//修改金币锁密码
		public static const MODI_LOCK_PW:String = urlPre + "/home/change_pay_password";
		
		//重置金币锁密码
		public static const FIND_LOCK_PW:String = urlPre + "/home/find_pay_password";
		
		//校验金币锁密码
		public static const CHECK_LOCK_PW:String = urlPre + "/home/check_pay_password";
		
		//转账金币
		public static const TRANS_COIN:String = urlPre + "/home/pay_transfer";
		
	}
}