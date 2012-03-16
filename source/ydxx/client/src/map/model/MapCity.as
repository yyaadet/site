package map.model
{
	import city.model.City;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import images.AssetsManager;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import utils.FormatText;
	import utils.GameManager;
	import utils.components.GameImage;

	/**
	 * 地图城池类 
	 * @author StarX
	 * 
	 */	
	public class MapCity extends UIComponent
	{
		//郡城
		private const JUN:int = 2;
		private const JUN_NAME:String = "郡城";
		public static const JUN_WIDTH:int = 80;
		private const JUN_HEIGHT:int = 43;
		
		//州城
		private const ZHOU:int = 3;
		private const ZHOU_NAME:String = "州城";
		private const ZHOU_WIDTH:int = 100;
		private const ZHOU_HEIGHT:int = 69;
		
		//都城
		private const DOU:int = 4;
		private const DOU_NAME:String = "都城";
		private const DOU_WIDTH:int = 120;
		private const DOU_HEIGHT:int = 86;
		
		private var _uniqID:int = 0;
		
		//城池对象
		private var _gameCity:City = null;
		
		//城池原始总士卒
		private var _soliderTotal:int = 0;
		
		//城池士卒
		private var _soliderNum:int = 0;
		
		//是否正在显示对抗信息窗口
		private var _isShow:Boolean = false;
		
		//是否可攻击状态
		private var _isAttack:Boolean = false;
		
		//是否可入城
		private var _isEnterCity:Boolean = false;
		
		//是否选中
		private var _selected:Boolean = false;
		
		//新手保护结束时间
		private var _endProtectTime:int = 0;
		
		//是否新手保护状态
		private var isProtect:Boolean = false;

		//城池图片
		private var swfLoad:GameImage = null;
		
		//用来计算两次单击之前的时差
		private var time1:int = 0;
		
		//火焰
		private var fire:MapFire = null;
		private	var fireX:int = 0;
		private	var fireY:int = 0;
		private	var fireWidth:int = 0;
		private	var fireHeight:int = 0;
		private var _firing:Boolean = false;
			
		
		public function MapCity()
		{
			super();
			
			swfLoad = new GameImage();
			swfLoad.x = 0;
			swfLoad.y = 0;
			this.addChild(swfLoad);
			swfLoad.addEventListener(MouseEvent.CLICK, swfLoadClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, cityOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, cityOut);
			
		}
		
		/**
		 * 显示城池图片 
		 * 
		 */		
		public function showCity():void
		{
			switch (gameCity.level)
			{
				case JUN:
				{
					this.width = JUN_WIDTH;
					this.height = JUN_HEIGHT;
					var junClass:Class = AssetsManager.assetsMgr.MAP_JUN;
					var junBmp:Bitmap = new junClass();
					swfLoad.width = this.width;
					swfLoad.height = this.height;
					swfLoad.canSel = true;
					swfLoad.imageURL = junBmp;
					
					fireX = 1;
					fireY = 1;
					fireWidth = 66;
					fireHeight = 44;
					
					break;
				}
				
				case ZHOU:
				{
					this.width = ZHOU_WIDTH;
					this.height = ZHOU_HEIGHT;
					var zhouClass:Class = AssetsManager.assetsMgr.MAP_ZHOU;
					var zhouBmp:Bitmap = new zhouClass();
					swfLoad.width = this.width;
					swfLoad.height = this.height;
					swfLoad.canSel = true;
					swfLoad.imageURL = zhouBmp;
					
					fireX = 2;
					fireY = 6;
					fireWidth = 85;
					fireHeight = 55;
					
					break;
				}
				
				case DOU:
				{
					this.width = DOU_WIDTH;
					this.height = DOU_HEIGHT;
					var douClass:Class = AssetsManager.assetsMgr.MAP_DOU;
					var douBmp:Bitmap = new douClass();
					swfLoad.width = this.width;
					swfLoad.height = this.height;
					swfLoad.canSel = true;
					swfLoad.imageURL = douBmp;
					
					fireX = 1;
					fireY = 4;
					fireWidth = 126;
					fireHeight = 75;
					
					break;
				}
				
				default:
				{
					break;
				}
			}
			
			swfLoad.width = this.width;
			swfLoad.height = this.height;
			
			setToolTip();
		}
		
		/**
		 * 刷新城池信息 
		 * 
		 */		
		public function refresh():void
		{
			setToolTip();
			
			if (gameCity.cityState == 2)
				showFire();
			else
				stopFire();
		}
		
		/**
		 * 显示火焰效果 
		 * 
		 */		
		public function showFire():void
		{
			if (fire == null)
			{
				fire = new MapFire();
				fire.x = fireX;
				fire.y = fireY;
				fire.fireWidth = fireWidth;
				fire.fireHeight = fireHeight;
				this.addChild(fire);
				fire.addEventListener(MouseEvent.CLICK, onFireClick);
				fire.startFire();
			}
			else
				fire.startFire();
			
			_firing = true;
		}
		
		private function onFireClick(evt:MouseEvent):void
		{
			swfLoadClick(evt);
		}
		
		/**
		 * 停止火焰效果 
		 * 
		 */		
		public function stopFire():void
		{
			if (fire != null)
			{
				_firing = false;
				fire.removeEventListener(MouseEvent.CLICK, onFireClick);
				fire.remove();
				this.removeChild(fire);
				fire = null;
			}
		}
		
		/**
		 * 显示城池提示信息 
		 * 
		 */		
		private function setToolTip():void
		{
			var tip:String = "";
			
			tip = FormatText.packegText("城池 ") + FormatText.packegText(gameCity.cityName, FormatText.GREEN) + "\n" +
			      FormatText.packegText("所在 ") + FormatText.packegText(gameCity.upName, FormatText.GREEN) + "\n";
			
			var selfID:int = GameManager.gameMgr.wubao.sphereID;
			var targetID:int = gameCity.sphereID;
			
			if (gameCity.sphereName != "")
			{
				tip += FormatText.packegText("势力 ") + FormatText.packegText(gameCity.sphereName, FormatText.GREEN);
				
				if (GameManager.gameMgr.dipList.isAlli(selfID, targetID))
					tip += "(同盟)" + "\n";
				else if (GameManager.gameMgr.dipList.isEne(selfID, targetID))
					tip += "(敌对)" + "\n";
				else
					tip += "\n";
			}
			else
				tip += FormatText.packegText("势力 ") + FormatText.packegText("无", FormatText.GREEN) + "\n";
			tip += FormatText.packegText("武将 ") + FormatText.packegText(gameCity.generalNum.toString(), FormatText.GREEN) + "\n";	
			tip += FormatText.packegText("玩家 ") + FormatText.packegText(gameCity.userList.length.toString(), FormatText.GREEN);
				
			this.toolTip = tip;
		}
		
		/**
		 * 鼠标移至城池上 
		 * @param evt
		 * 
		 */		
		private function cityOver(evt:MouseEvent):void
		{
			setToolTip();
		}
		
		/**
		 * 鼠标移出城池 
		 * @param evt
		 * 
		 */		
		private function cityOut(evt:MouseEvent):void
		{
		}
		
		/**
		 * 点击城池动画时，派发城池点击事件 
		 * @param evt
		 * 
		 */		
		private function swfLoadClick(evt:MouseEvent):void
		{
			dispatchEvent(evt.clone());
		}
		
		//=========================================================
		//城池属性
		//=========================================================
		
		public function get uniqID():int
		{
			return _uniqID;
		}
		
		public function set uniqID(param:int):void
		{
			_uniqID = param;
		}
		
		public function get gameCity():City
		{
			return _gameCity;
		}
		
		public function set gameCity(param:City):void
		{
			_gameCity = param;
		}
		
		public function get soliderTotal():int
		{
			return _soliderTotal;
		}
		
		public function set soliderTotal(param:int):void
		{
			_soliderTotal = param;
		}
		
		public function get soliderNum():int
		{
			return _soliderNum;
		}
		
		public function set soliderNum(param:int):void
		{
			_soliderNum = param;
		}
		
		public function get isShow():Boolean
		{
			return _isShow;
		}
		
		public function set isShow(param:Boolean):void
		{
			_isShow = param;
		}
		
		public function get isAttack():Boolean
		{
			return _isAttack;
		}
		
		public function set isAttack(param:Boolean):void
		{
			_isAttack = param;
		}
		
		public function get isEnterCity():Boolean
		{
			return _isEnterCity;
		}
		
		public function set isEnterCity(param:Boolean):void
		{
			_isEnterCity = param;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(param:Boolean):void
		{
			_selected = param;
		}
		
		public function get firing():Boolean
		{
			return _firing;
		}
		
		public function set firing(param:Boolean):void
		{
			_firing = param;
		}
		
		public function set endProtectTime(param:int):void
		{
			this._endProtectTime = param;
		}

		public function get endProtectTime():int
		{
			return this._endProtectTime;
		}
		
	}
}