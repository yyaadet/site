package utils
{
	
	/**
	 * 窗体的格式化文本 
	 * @author StarX
	 * 
	 */	
	public class FormatText
	{
		public static const DEFAULT:String = "#C8D8A9";
		public static const YELLOW:String = "#FFAE00"; 
		public static const BLUE:String = "#0000FF"; 
		public static const RED:String = "#E15800"; 
		public static const GREEN:String = "#00FF00"; 
		public static const WHITE:String = "#FFFFFF";
		public static const BLACK:String = "#000000";
		
		/**
		 * 组合文本样式 
		 * @param content
		 * @param color
		 * @param size
		 * @param face
		 * @param bold
		 * @return 
		 * 
		 */		
		public static function packegText(content:String = "", color:String = YELLOW, size:String = "12", face:String = "新宋体", bold:Boolean = false):String
		{
			var ret:String = "";
			
			if (bold)
				ret += "<B>";
				
			ret += "<FONT FACE='" + face + "' SIZE='" + size + "' COLOR='" + color + "'>" + content + "</FONT>";
			
			if (bold)
				ret += "</B>";
				
			return ret;
		}
		
	}
}