package utils
{
	import flash.display.BlendMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.effects.Move;
	import mx.events.EffectEvent;
	
	/**
	 * 飘动显示字幕 
	 * @author bxl
	 * 
	 */	
	public class MoveTip
	{
		private var label1:UIComponent = null;
			
		private var labelList:Array = [];
		
		private var index:int = 0;
		
		private var _txtColor:int = 0;
		
		private var _txtFont:String = "";
		
		private var _txtSize:int = 12;
		
		private var _objWidth:int = 0;
		
		private var _objHeight:int = 0;
		
		private var _objX:int = 0;
		
		private var _objY:int = 0;
		
		private var _content:String = ""; 
		
		private var _container:UIComponent = null;
		
		public function MoveTip()
		{
		}
		
		public function start():void
		{
			if (content == "") return;
			
			var tf:TextField = new TextField();
			tf.width = objWidth;
			tf.height = objHeight;
			tf.x = 0;
			tf.y = 0;
			tf.text = content;
			tf.autoSize = "center";
			tf.textColor = txtColor;
			tf.blendMode = BlendMode.LAYER;
			
			var tf1:TextFormat = new TextFormat();
			tf1.font = txtFont;
			tf1.size = txtSize;
			tf1.bold = true; 
			tf.setTextFormat(tf1);
			
			label1 = new UIComponent();
			index ++;
			label1.id = "label" + index.toString();
			label1.x = objX;
			label1.y = objY;
			label1.width = objWidth;
			label1.height = objHeight;
			label1.addChild(tf);
			container.addChild(label1);
			labelList.push(label1);
			
			var fade1:Fade = new Fade();
			fade1.target = label1;
			fade1.alphaFrom = 1;
			fade1.alphaTo = 0;
			fade1.duration = 3000;
			fade1.play();
			fade1.addEventListener(EffectEvent.EFFECT_END, onFadeEnd);
			
			var move1:Move = new Move();
			move1.target = label1;
			move1.xFrom = label1.x;
			move1.xTo = label1.x;
			move1.yFrom = label1.y;
			move1.yTo = label1.y - 30;
			move1.duration = 3000;
			move1.play();
			move1.addEventListener(EffectEvent.EFFECT_END, onMoveEnd);
		}

		/**
		 * 淡出效果结束事件 
		 * @param evt
		 * 
		 */		
		private function onFadeEnd(evt:EffectEvent):void
		{
			if (evt.target is Fade)
			{
				var fade:Fade = evt.target as Fade;
				if (fade != null)
				{
					fade.removeEventListener(EffectEvent.EFFECT_END, onFadeEnd);
					fade.target = null;
					fade = null;
				}
			}
			
			removeAttack();
		}
		
		/**
		 * 移动结束事件 
		 * @param evt
		 * 
		 */			
		private function onMoveEnd(evt:EffectEvent):void
		{
			if (evt.target is Move)
			{
				var move:Move = evt.target as Move;
				if (move != null)
				{
					move.removeEventListener(EffectEvent.EFFECT_END, onMoveEnd);
					move.target = null;
					move = null;
				}
			}
		}
		
		/**
		 * 删除所有的战斗数字标签
		 * @param evt
		 * 
		 */			
		private function removeAttack():void
		{
			var i:int = 0;
			var j:int = 0;
			var count:int = labelList.length;
			var lblTemp:UIComponent = null;
			
			for (i = 0; i < count; i++)
			{
				lblTemp = labelList[i] as UIComponent;
				
				if (lblTemp != null)
				{
					for (j = 0; j < lblTemp.numChildren; j++)
						lblTemp.removeChildAt(j);
					
					if (lblTemp.parent != null)
						container.removeChild(lblTemp);
					lblTemp = null;
				}
			}
			
			labelList.length = 0;
		}
		
		//=====================================================================================
		// 属性
		//=====================================================================================
		
		public function get txtColor():int
		{
			return _txtColor;
		}
		
		public function set txtColor(param:int):void
		{
			_txtColor = param;
		}
			
		public function get txtFont():String
		{
			return _txtFont;
		}
		
		public function set txtFont(param:String):void
		{
			_txtFont = param;
		}
			
		public function get txtSize():int
		{
			return _txtSize;
		}
		
		public function set txtSize(param:int):void
		{
			_txtSize = param;
		}
			
		public function get objWidth():int
		{
			return _objWidth;
		}
		
		public function set objWidth(param:int):void
		{
			_objWidth = param;
		}
			
		public function get objHeight():int
		{
			return _objHeight;
		}
		
		public function set objHeight(param:int):void
		{
			_objHeight = param;
		}
			
		public function get objX():int
		{
			return _objX;
		}
		
		public function set objX(param:int):void
		{
			_objX = param;
		}
			
		public function get objY():int
		{
			return _objY;
		}
		
		public function set objY(param:int):void
		{
			_objY = param;
		}
			
		public function get content():String
		{
			return _content;
		}
		
		public function set content(param:String):void
		{
			_content = param;
		}
			
		public function get container():UIComponent
		{
			return _container;
		}
		
		public function set container(param:UIComponent):void
		{
			_container = param;
		}
			
	}
}