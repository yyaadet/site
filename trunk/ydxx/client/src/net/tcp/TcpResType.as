package net.tcp
{
	/**
	 * 响应消息类型 
	 * @author StarX
	 * 
	 */	
	public class TcpResType
	{
		public static const SUCCESS_CODE:int = 300;
		public static const SUCCESS:String = "成功";
		
		public static const CLIENT_ERROR_CODE:int = 301;
		public static const CLIENT_ERROR:String = "客户端请求格式有问题";
		
		public static const CLIENT_MSG_TYPE_NOT_FOUND_CODE:int = 302;
		public static const CLIENT_MSG_TYPE_NOT_FOUND:String = "客户端消息请求类型不存在";
		
		public static const HAVE_LOGIN_CODE:int = 303;
		public static const HAVE_LOGIN:String = "已经登录，禁止多点登录";
		
		public static const SERVER_ERROR_CODE:int = 350;
		public static const SERVER_ERROR:String = "服务器处理错误";
	}
}