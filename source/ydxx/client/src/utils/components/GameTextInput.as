package utils.components
{
	import mx.controls.TextInput;
	
	/**
	 * 游戏输入框组件 
	 * @author StarX
	 * 
	 */	
	public class GameTextInput extends TextInput
	{
		//是否限制汉字输入
		private var _isCH:Boolean = false;
		
		//是否限制数字输入
		private var _isNUM:Boolean = false;
		
		public function GameTextInput()
		{
			super();
			
			this.setStyle("paddingTop", 0);
			this.setStyle("paddingBottom", 0);
		}
		
		public function get isCH():Boolean
		{
			return _isCH;
		}
		
		public function set isCH(param:Boolean):void
		{
			_isCH = param;
			
			if (_isCH)
				this.restrict = "\u4e00-\u9fa5";
			else
				this.restrict = "";
		}
		
		public function get isNUM():Boolean
		{
			return _isNUM;
		}
		
		public function set isNUM(param:Boolean):void
		{
			_isNUM = param;
			
			if (_isNUM)
				this.restrict = "0-9";
			else
				this.restrict = "";
		}
		
	}
}