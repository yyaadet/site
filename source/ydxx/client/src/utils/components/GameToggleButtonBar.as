package utils.components
{
	import mx.controls.Button;
	import mx.controls.ToggleButtonBar;

	public class GameToggleButtonBar extends ToggleButtonBar
	{
		public function GameToggleButtonBar()
		{
			super();
			
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			this.width = w;
			this.height = h;
			this.setStyle("color", 0xFFFFFF);
			//this.setStyle("buttonWidth", 50);
			this.setStyle("buttonHeight", 22);
			this.setStyle("horizontalGap", 0);
			this.setStyle("horizontalAlign", "left");
			
			var btnList:Array = this.getChildren();
			for each(var btn:Button in btnList)
			{
				btn.setStyle("paddingLeft", 5);
				btn.setStyle("paddingRight", 5);
				btn.setStyle("paddingTop", 5);
				btn.setStyle("fontSize", 12);
				btn.setStyle("fontFamily", "新宋体");
			}
		}
		
	}
}