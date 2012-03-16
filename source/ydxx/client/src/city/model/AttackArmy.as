package city.model
{
	import flash.events.MouseEvent;
	
	import images.AssetsManager;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import utils.FormatText;
	import utils.PubUnit;
	
	import wubao.model.User;
	
	/**
	 * 地图军团类 
	 * @author StarX
	 * 
	 */	
	public class AttackArmy extends UIComponent
	{
		//军团ID
		private var _uniqID:int = 0;
		
		private var _gameUser:User = null;
		
		private var _index:int = 0;
		
		//是否攻方的军团
		private var _isAttack:Boolean = false;
		
		//军团动画的大小
		private var armyWidth:int = 50;
		private var armyHeigth:int = 48;
		
		private var lblUserName:Label = null;
		
		//军团动画加载器
		private var swfLoad:Canvas = null;
		
		public function AttackArmy()
		{
			super();
			
		}
		
		//=========================================================
		//公共函数
		//========================================================
		
		/**
		 * 初始化 
		 * 
		 */		
		public function init():void
		{
			this.width = armyWidth + 4;
			this.height = armyHeigth;
			
			//军团动画
			if (swfLoad == null)
			{
				swfLoad = new Canvas();
				swfLoad.x = 2;
				swfLoad.y = 0;
				swfLoad.width = armyWidth;
				swfLoad.height = armyHeigth;
				this.addChild(swfLoad);
				swfLoad.addEventListener(MouseEvent.CLICK, swfLoadClick);
				swfLoad.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				swfLoad.addEventListener(MouseEvent.MOUSE_UP, onUp);
			}
			
			if (lblUserName == null)
			{
				lblUserName = new Label();
				lblUserName.x = 0;
				lblUserName.y = 5;
				lblUserName.width = this.width;
				lblUserName.height = 20;
				this.addChild(lblUserName);
				lblUserName.text = "";
				lblUserName.setStyle("textAlign", "center");
				lblUserName.setStyle("fontSize", 12);
				lblUserName.setStyle("fontFamily", "新宋体");
				lblUserName.setStyle("color", PubUnit.WHITE);
			}
			
			this.addEventListener(MouseEvent.MOUSE_OVER, armyOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, armyOut);
		}
		
		private function swfLoadClick(evt:MouseEvent):void
		{
			dispatchEvent(evt.clone());
		}
		
		private function onDown(evt:MouseEvent):void
		{
			dispatchEvent(evt.clone());
		}
		
		private function onUp(evt:MouseEvent):void
		{
			dispatchEvent(evt.clone());
		}
		
		/**
		 * 设置军团提示信息 
		 * 
		 */		
		public function setTooTip():void
		{
			if (gameUser == null) return;
			
			if (gameUser.uniqID < 0)
			{
				this.toolTip = "";
				return;
			}
			
			var tip:String = "";
			tip = FormatText.packegText("名称：") + FormatText.packegText(gameUser.userName, FormatText.GREEN) + "\n" + 
			      FormatText.packegText("等级：") + FormatText.packegText(gameUser.level.toString(), FormatText.GREEN) + "\n" +
			      FormatText.packegText("势力：") + FormatText.packegText(gameUser.sphereName, FormatText.GREEN);
			      
			this.toolTip = tip;
			
		}
		
		/**
		 * 清空 
		 * 
		 */		
		public function clear():void
		{
			swfLoad.clearStyle("backgroundImage");
			this.removeChild(swfLoad);
			swfLoad = null;
		}
		
		public function refresh():void
		{
			if (gameUser != null)
				lblUserName.text = gameUser.userName;
			setTooTip();
			
			var armyClass:Class;
			if (isAttack)
				armyClass = AssetsManager.assetsMgr.MAP_GONG;
			else
				armyClass = AssetsManager.assetsMgr.MAP_SHOU;
			
			if (swfLoad != null)
			{
				swfLoad.setStyle("backgroundImage", armyClass);
				swfLoad.setStyle("backgroundSize", "100%");
			}
		}
		
		//=========================================================
		//私有函数
		//=========================================================
		
		/**
		 * 鼠标移至军团上 
		 * @param evt
		 * 
		 */		
		private function armyOver(evt:MouseEvent):void
		{
			PubUnit.addGlow(swfLoad, PubUnit.GREEN);
			setTooTip();
		}
		
		/**
		 * 鼠标移出军团 
		 * @param evt
		 * 
		 */		
		private function armyOut(evt:MouseEvent):void
		{
			cursorManager.removeAllCursors();
			PubUnit.clearGlow(swfLoad);
		}
		
		//=========================================================
		//军团属性
		//=========================================================
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}
		
		public function get gameUser():User
		{
			return _gameUser;
		}
		
		public function set gameUser(param:User):void
		{
			_gameUser = param;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(param:int):void
		{
			_index = param;
		}
		
		public function get isAttack():Boolean
		{
			return _isAttack;
		}
		
		public function set isAttack(param:Boolean):void
		{
			_isAttack = param;
		}
		
	}
}