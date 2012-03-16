package map.model
{
	import army.model.Army;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import general.model.General;
	
	import images.AssetsManager;
	
	import map.MapManager;
	import map.MapUtil;
	import map.events.ArmyMoveEvent;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	import sphere.model.Sphere;
	
	import utils.FormatText;
	import utils.GameManager;
	import utils.PubUnit;
	
	import wubao.model.User;
	
	/**
	 * 地图军团类 
	 * @author StarX
	 * 
	 */	
	public class MapArmy extends UIComponent
	{
		//==========================================
		//军团状态
		//==========================================
		
		//静止
		public static const STOP:int = 0
		
		//移动
		public static const MOVE:int = 1;
		
		//安营
		public static const CAMP:int = 2;
		
		//战斗
		public static const WAR:int = 3;
		
		//军团ID
		private var _uniqID:int = 0;
		
		//军团数据
		private var _gameArmy:Army = null;
		
		//武将
		private var _gameGeneral:General = null;
		
		//军团是否选中
		private var _selected:Boolean = false;
		
		//是否正在显示军团对抗信息窗口
		private var _isShow:Boolean = false;
		
		//是否可攻击状态
		private var _isAttack:Boolean = false;
		
		//是否战争状态
		private var _isWar:Boolean = false;
		
		//军团当前状态
		private var _armyState:int = 0;
		
		//是否水军
		private var _isNavy:Boolean = false;
		
		//是否冲车
		private var _isChong:Boolean = false;
		
		//军团当前的位置是否在江海里
		private var _isInSea:Boolean = false;
		
		//是否己方的军团
		private var _isSelf:Boolean = false;
		
		//是否同势力的军团
		private var _isSameSpere:Boolean = false;
		
		//是否同盟的军团
		private var _isAlli:Boolean = false;
		
		//是否敌方的军团
		private var _isEne:Boolean = false;
		
		//血条大小
		private var bloodWidth:int = 30;
		private var bloodHeight:int = 2; 
		
		//军团动画的大小
		private var armyWidth:int = 40;
		private var armyHeigth:int = 30;
		
		//光圈的大小
		private var circleWidth:int = 50;
		private var circleHeight:int = 40; 
		
		//军团动画加载器
		private var swfLoad:Canvas = null;
		
		//光圈加载器
		private var circleLoad:Canvas = null; 
		
		//动画定时器
		private var swfTimer:Timer = null;
		
		//动画第一帧
		private var frame1:Class;
		//动画第二帧
		private var frame2:Class;
		private var frameIndex:int = 0;
		
		//路径序列
		private var pathList:Array;
		
		//当前的移动序列
		private var moveIndex:int = 0;
		
		//用来计算两次单击之前的时差
		private var time1:int = 0;
		
		public function MapArmy()
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
			//军团由两部分组成，上面是血条，下面是军团动画
			this.width = circleWidth;
			this.height = circleHeight;
			
			armyWidth = circleWidth - 10;
			armyHeigth = circleHeight - 10;
			
			//光圈
			if (circleLoad == null)
			{
				circleLoad = new Canvas();
				circleLoad.x = 0;
				circleLoad.y = bloodHeight + 3;
				circleLoad.width = circleWidth;
				circleLoad.height = circleHeight;
				circleLoad.setStyle("backgroundImage", AssetsManager.assetsMgr.CIRCLE);
				circleLoad.setStyle("backgroundSize", "100%");
				this.addChild(circleLoad);
				circleLoad.visible = false;
				circleLoad.includeInLayout = false;
			}
			
			//军团动画
			if (swfLoad == null)
			{
				swfLoad = new Canvas();
				swfLoad.x = 5;
				swfLoad.y = bloodHeight;
				swfLoad.width = armyWidth;
				swfLoad.height = armyHeigth;
				this.addChild(swfLoad);
				swfLoad.addEventListener(MouseEvent.CLICK, swfLoadClick);
			}
			
			if (swfTimer == null)
			{
				swfTimer = new Timer(200);
				swfTimer.addEventListener(TimerEvent.TIMER, onTimer);
			}
			
			this.addEventListener(MouseEvent.MOUSE_OVER, armyOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, armyOut);
			
			stopMove();
		}
		
		/**
		 * 开始移动 
		 * @param path
		 * 
		 */		
		public function startMove(moveList:Array):void
		{
			stopMove();
			
			pathList = moveList;
			if (pathList == null || pathList.length < 1) return;
			
			moveRate = getMoveQua();
			moveIndex = 0;
			
			moveArmy();
		}
		
		/**
		 * 停止移动 
		 * 
		 */		
		public function stopMove():void
		{
			if (swfTimer != null)
				swfTimer.stop();
			
			this.removeEventListener(Event.ENTER_FRAME, moveStep);
			stepCount = 0;
			count = 0;
			gridCount = 0;
			
			armyState = STOP;
		}
		
		/**
		 * 设置军团提示信息 
		 * 
		 */		
		public function setTooTip():void
		{
			if (gameGeneral == null) return;
			
			var tip:String = "";
			var ary:Array = [];
			ary = PubUnit.getGeneralInfo(gameGeneral);
			
			if (isSelf)
			{
				
				tip = FormatText.packegText("武将 ") + FormatText.packegText(gameGeneral.generalName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("等级 ") + FormatText.packegText(gameGeneral.soliderTrain.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("部曲 ") + FormatText.packegText(gameGeneral.soliderName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("阵型 ") + FormatText.packegText(gameGeneral.useZhenName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("士卒 ") + FormatText.packegText(gameGeneral.soliderTotal.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("伤兵 ") + FormatText.packegText(gameGeneral.hurtNum.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("士气 ") + FormatText.packegText(gameGeneral.soliderSpirit.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("攻击 ") + FormatText.packegText(ary[0], FormatText.GREEN) + "\n" +
				      FormatText.packegText("防御 ") + FormatText.packegText(ary[1], FormatText.GREEN) + "\n" +
				      FormatText.packegText("机动 ") + FormatText.packegText(ary[2], FormatText.GREEN) + "\n" +
				      FormatText.packegText("钱 ") + FormatText.packegText(gameArmy.money.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("粮 ") + FormatText.packegText(gameArmy.food.toString(), FormatText.GREEN);
			}
			else if (isAlli)
			{
				tip = FormatText.packegText("武将 ") + FormatText.packegText(gameGeneral.generalName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("等级 ") + FormatText.packegText(gameGeneral.soliderTrain.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("主公 ") + FormatText.packegText(gameGeneral.userName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("势力 ") + FormatText.packegText(gameGeneral.sphereName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("部曲 ") + FormatText.packegText(gameGeneral.soliderName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("阵型 ") + FormatText.packegText(gameGeneral.useZhenName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("士卒 ") + FormatText.packegText(gameGeneral.soliderTotal.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("攻击 ") + FormatText.packegText(ary[0], FormatText.GREEN) + "\n" +
				      FormatText.packegText("防御 ") + FormatText.packegText(ary[1], FormatText.GREEN) + "\n" +
				      FormatText.packegText("机动 ") + FormatText.packegText(ary[2], FormatText.GREEN)
			} 
			else if (isEne)
			{
				tip = FormatText.packegText("武将 ") + FormatText.packegText(gameGeneral.generalName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("等级 ") + FormatText.packegText(gameGeneral.soliderTrain.toString(), FormatText.GREEN) + "\n" +
					  FormatText.packegText("主公 ") + FormatText.packegText(gameGeneral.userName, FormatText.GREEN) + "\n" +
					  FormatText.packegText("势力 ") + FormatText.packegText(gameGeneral.sphereName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("部曲 ") + FormatText.packegText(gameGeneral.soliderName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("阵型 ") + FormatText.packegText(gameGeneral.useZhenName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("士卒 ") + FormatText.packegText(gameGeneral.soliderTotal.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("攻击 ") + FormatText.packegText(ary[0], FormatText.GREEN) + "\n" +
				      FormatText.packegText("防御 ") + FormatText.packegText(ary[1], FormatText.GREEN) + "\n" +
				      FormatText.packegText("机动 ") + FormatText.packegText(ary[2], FormatText.GREEN);
			}	
			else
			{
				tip = FormatText.packegText("武将 ") + FormatText.packegText(gameGeneral.generalName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("等级 ") + FormatText.packegText(gameGeneral.soliderTrain.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("主公 ") + FormatText.packegText(gameGeneral.userName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("势力 ") + FormatText.packegText(gameGeneral.sphereName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("部曲 ") + FormatText.packegText(gameGeneral.soliderName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("阵型 ") + FormatText.packegText(gameGeneral.useZhenName, FormatText.GREEN) + "\n" +
				      FormatText.packegText("士卒 ") + FormatText.packegText(gameGeneral.soliderTotal.toString(), FormatText.GREEN) + "\n" +
				      FormatText.packegText("攻击 ") + FormatText.packegText(ary[0], FormatText.GREEN) + "\n" +
				      FormatText.packegText("防御 ") + FormatText.packegText(ary[1], FormatText.GREEN) + "\n" +
				      FormatText.packegText("机动 ") + FormatText.packegText(ary[2], FormatText.GREEN);
			}	
						 
			this.toolTip = tip;
			
		}
		
		/**
		 * 清空 
		 * 
		 */		
		public function clear():void
		{
			stopMove();
			
			circleLoad.clearStyle("backgroundImage");
			this.removeChild(circleLoad);
			circleLoad = null;
			
			swfLoad.clearStyle("backgroundImage");
			this.removeChild(swfLoad);
			swfLoad = null;
			
			swfTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			swfTimer = null;
		}
		
		public function refresh():void
		{
			setTooTip();
			showBlood();
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
			if (isSelf)
				PubUnit.addGlow(swfLoad, PubUnit.GREEN);
			else if (isAlli)
				PubUnit.addGlow(swfLoad, PubUnit.BLUE);
			else if (isEne)
			{
				PubUnit.addGlow(swfLoad, PubUnit.RED);
				if (isAttack)
				{
					var attack:Class = AssetsManager.assetsMgr.CUR_ATTACK;
					cursorManager.setCursor(attack);
				}
			}
			else
				PubUnit.addGlow(swfLoad, PubUnit.RED);
			
			setTooTip();
			showBlood();
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
		
		/**
		 * 点击军团动画时，派发点击事件 
		 * @param evt
		 * 
		 */		
		private function swfLoadClick(evt:MouseEvent):void
		{
			dispatchEvent(evt.clone());
		}
		
		//每次移动的坐标位移
		private var xLen:int = 0;	
		private var yLen:int = 0;
		
		//根据玩家设定的军团移动质量计算移动的步长
		private var moveRate:int = 0;
		
		private var moveAry:Array = [];
		private var intvTime:int = 0;
		
		private var timeList:Array = [];
		private var funcID:int = 0;
		private var t0:int = 0;
		private var t1:int = 0;
		
		/**
		 * 移动军团到指定的路径序列 
		 * @param index 路径序列索引
		 * 每一格分为10个步长来移动，每个步长为1个像素
		 * 
		 */
		private function moveArmy():void
		{
			if (moveIndex >= pathList.length)
			{ 
				stopMove();
				return;
			}
			
			armyState = MOVE;
			t0 = getTimer();
			timeList.length = 0;
			
			var timeLeft:int = 0; 
			
			for (var i:int = 0; i < pathList.length; i++)
			{
				moveAry = pathList[i];
				intvTime = moveAry[4] / (10 / moveRate);
				timeLeft = moveAry[4] - intvTime * (10 / moveRate);
				
				var xFrom:int = int(moveAry[0]) * MapUtil.mapGridW;
				var xTo:int = int(moveAry[2]) * MapUtil.mapGridW;
				var yFrom:int = int(moveAry[1]) * MapUtil.mapGridH;
				var yTo:int = int(moveAry[3]) * MapUtil.mapGridH;
				
				xLen = (xTo - xFrom) / 10 * moveRate;
				yLen = (yTo - yFrom) / 10 * moveRate;
				
				if (i == 0)
				{
					this.x = xFrom - this.width / 2;
					this.y = yFrom - this.height / 2;
				}
				
				for(var j:int = 1; j <= 10 / moveRate; j++)
				{
					if (j == 1)
						t0 += timeLeft;
					t0 += intvTime;
					var obj:Object = {time:t0, xlen:xLen, ylen:yLen};
					timeList.push(obj);
				}
			}
			
			if (this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, moveStep);
			
			this.addEventListener(Event.ENTER_FRAME, moveStep);
		}
		
		//移动步长的次数
		private var stepCount:int = 0;
		
		private var count:int = 0;
		
		private var gridCount:int = 0;
		
		/**
		 * 每次移动一个步长 
		 * @param evt
		 * 
		 */		
		private function moveStep(evt:Event):void
		{
			t1 = getTimer();
			
			var obj:Object = timeList[count];
			
			if (t1 >= obj.time)
			{
				this.x += obj.xlen;
				this.y += obj.ylen;
				
				stepCount ++;
				count ++;
			}
			
			//移动完一个格子的时候
			if (stepCount >= 10 / moveRate)
			{
				stepCount = 0;
				removePoint();
				gridCount ++;
			}
			
			if (count >= timeList.length)
				stopMove();
		}
		
		/**
		 * 每移动完一个格子消除一个地图上的用来描述路线的圆点 
		 * 
		 */		
		private function removePoint():void
		{
			//走完一步派发完成事件
			var event:ArmyMoveEvent = new ArmyMoveEvent(ArmyMoveEvent.MOVE_STEP);
			var moveAry:Array = pathList[gridCount];
			event.moveStep = gridCount;
			event.armyID = gameArmy.uniqID;
			event.mapX = moveAry[2];
			event.mapY = moveAry[3];
			dispatchEvent(event);
		}
		
		/**
		 * 根据玩家设定的移动质量计算移动的步长 
		 * @return 
		 * 
		 */		
		private function getMoveQua():int
		{
			var ret:int = 0;
			var moveQua:int = MapManager.mapMgr.moveQua;
			
			if (moveQua == 0)
				moveQua = 4;
			
			if (moveQua == 1)
				ret = 10;
			else if (moveQua == 2)
				ret = 5;
			else if (moveQua == 3)
				ret = 2;
			else if (moveQua == 4)
				ret = 1;
			
			return ret;
		}
		
		/**
		 * 显示血条 
		 * 
		 */		
		private function showBlood():void
		{
			if (gameGeneral == null) return;
			
			var armyNum:int = 0;
			var armyTotal:int = 0;
			
			armyNum = gameGeneral.soliderNum;
			armyTotal = gameGeneral.soliderTotal;
			 
			if (armyTotal <= 0) return;
			if (armyNum <= 0) return;
			if (armyNum > armyTotal) return;
			
			var leftWidth:int = 0;
			var leftColor:uint = 0;
			var costWidth:int = 0;
			var costColor:uint = PubUnit.BLACK;
			var per:Number = 0;
			
			per = armyNum / armyTotal;
			
			if (per >= 0.8)
				leftColor = PubUnit.GREEN;
			else if (per >= 0.3)
				leftColor = PubUnit.CYAN;
			else
				leftColor = PubUnit.RED;
				 
			leftWidth = int(per * bloodWidth);
			costWidth = bloodWidth - leftWidth;
			
			this.graphics.clear();
			this.graphics.beginFill(leftColor);
			this.graphics.drawRect(10, 0, leftWidth, bloodHeight);
			this.graphics.endFill();
			
			this.graphics.beginFill(costColor);
			this.graphics.drawRect(leftWidth + 10, 0, costWidth, bloodHeight);
			this.graphics.endFill();
		}
		
		/**
		 * 根据军团当前状态显示动画 
		 * 
		 */		
		private function showState():void
		{
			var army:Class;
			
			if (circleLoad != null)
			{
				if (selected)
				{
					circleLoad.visible = true;
					circleLoad.includeInLayout = true;
				}
				else
				{
					circleLoad.visible = false;
					circleLoad.includeInLayout = false;
				}
			}
					
			switch(armyState)
			{
				//静止
				case STOP:
				{
					stopFlash();
					
					break;
				}
				
				//移动
				case MOVE:
				{
					moveFlash();
					
					break;
				}
				
				//战斗
				case WAR:
				{
					warFlash();
					
					break;
				}
				
				default:
				{
					break;
				}
			}
		}
		
		/**
		 * 军团静止时的动画实现 
		 * 
		 */		
		private function stopFlash():void
		{
			if (swfTimer != null && swfTimer.running)
				swfTimer.stop();
				
			var stop:Class;
			if (isSelf)
			{
				if (isNavy && isInSea)
					stop = AssetsManager.assetsMgr.SHIP;
				else if (isChong)
					stop = AssetsManager.assetsMgr.CHONG;
				else
					stop = AssetsManager.assetsMgr.MOVE1_G;
			}
			else if (isAlli || isSameSpere)
			{
				if (isNavy && isInSea)
					stop = AssetsManager.assetsMgr.SHIP;
				else if (isChong)
					stop = AssetsManager.assetsMgr.CHONG;
				else
					stop = AssetsManager.assetsMgr.MOVE1_B;
			}
			else if (isEne)
			{
				if (isNavy && isInSea)
					stop = AssetsManager.assetsMgr.SHIP;
				else if (isChong)
					stop = AssetsManager.assetsMgr.CHONG;
				else
					stop = AssetsManager.assetsMgr.MOVE1_R;
			}
			else
			{
				if (isNavy && isInSea)
					stop = AssetsManager.assetsMgr.SHIP;
				else if (isChong)
					stop = AssetsManager.assetsMgr.CHONG;
				else
					stop = AssetsManager.assetsMgr.MOVE1_R;
			}
			
			if (swfLoad != null)
			{
				swfLoad.setStyle("backgroundImage", stop);
				swfLoad.setStyle("backgroundSize", "100%");
			}
			
			showBlood();
		}
		
		/**
		 * 军团移动时的动画实现 
		 * 
		 */		
		private function moveFlash():void
		{
			if (swfTimer == null) return;
			
			if (swfTimer.running)
				swfTimer.stop();
				
			if (isSelf)
			{
				if (isNavy && isInSea)
				{
					frame1 = AssetsManager.assetsMgr.SHIP;
					frame2 = AssetsManager.assetsMgr.SHIP;
				}
				else if (isChong)
				{
					frame1 = AssetsManager.assetsMgr.CHONG;
					frame2 = AssetsManager.assetsMgr.CHONG;
				}
				else
				{
					frame1 = AssetsManager.assetsMgr.MOVE1_G;
					frame2 = AssetsManager.assetsMgr.MOVE2_G;
				}
			}
			else if (isAlli || isSameSpere)
			{
				if (isNavy && isInSea)
				{
					frame1 = AssetsManager.assetsMgr.SHIP;
					frame2 = AssetsManager.assetsMgr.SHIP;
				}
				else if (isChong)
				{
					frame1 = AssetsManager.assetsMgr.CHONG;
					frame2 = AssetsManager.assetsMgr.CHONG;
				}
				else
				{
					frame1 = AssetsManager.assetsMgr.MOVE1_B;
					frame2 = AssetsManager.assetsMgr.MOVE2_B;
				}
			}
			else if (isEne)
			{
				if (isNavy && isInSea)
				{
					frame1 = AssetsManager.assetsMgr.SHIP;
					frame2 = AssetsManager.assetsMgr.SHIP;
				}
				else if (isChong)
				{
					frame1 = AssetsManager.assetsMgr.CHONG;
					frame2 = AssetsManager.assetsMgr.CHONG;
				}
				else
				{
					frame1 = AssetsManager.assetsMgr.MOVE1_R;
					frame2 = AssetsManager.assetsMgr.MOVE2_R;
				}
			}
			else
			{
				if (isNavy && isInSea)
				{
					frame1 = AssetsManager.assetsMgr.SHIP;
					frame2 = AssetsManager.assetsMgr.SHIP;
				}
				else if (isChong)
				{
					frame1 = AssetsManager.assetsMgr.CHONG;
					frame2 = AssetsManager.assetsMgr.CHONG;
				}
				else
				{
					frame1 = AssetsManager.assetsMgr.MOVE1_R;
					frame2 = AssetsManager.assetsMgr.MOVE2_R;
				}
			}
			
			showBlood();
			swfTimer.start(); 
		}
		
		/**
		 * 军团战斗时的动画实现 
		 * 
		 */		
		private function warFlash():void
		{
			if (swfTimer == null) return;
			
			if (swfTimer.running)
				swfTimer.stop();
				
			if (isSelf)
			{
				if (isNavy && isInSea)
				{
					frame1 = AssetsManager.assetsMgr.SHIP;
					frame2 = AssetsManager.assetsMgr.SHIP;
				}
				else if (isChong)
				{
					frame1 = AssetsManager.assetsMgr.CHONG;
					frame2 = AssetsManager.assetsMgr.CHONG;
				}
				else
				{
					frame1 = AssetsManager.assetsMgr.WAR1_G;
					frame2 = AssetsManager.assetsMgr.WAR2_G;
				}
			}
			else if (isAlli || isSameSpere)
			{
				if (isNavy && isInSea)
				{
					frame1 = AssetsManager.assetsMgr.SHIP;
					frame2 = AssetsManager.assetsMgr.SHIP;
				}
				else if (isChong)
				{
					frame1 = AssetsManager.assetsMgr.CHONG;
					frame2 = AssetsManager.assetsMgr.CHONG;
				}
				else
				{
					frame1 = AssetsManager.assetsMgr.WAR1_B;
					frame2 = AssetsManager.assetsMgr.WAR2_B;
				}
			}
			else if (isEne)
			{
				if (isNavy && isInSea)
				{
					frame1 = AssetsManager.assetsMgr.SHIP;
					frame2 = AssetsManager.assetsMgr.SHIP;
				}
				else if (isChong)
				{
					frame1 = AssetsManager.assetsMgr.CHONG;
					frame2 = AssetsManager.assetsMgr.CHONG;
				}
				else
				{
					frame1 = AssetsManager.assetsMgr.WAR1_R;
					frame2 = AssetsManager.assetsMgr.WAR2_R;
				}
			}
			else
			{
				if (isNavy && isInSea)
				{
					frame1 = AssetsManager.assetsMgr.SHIP;
					frame2 = AssetsManager.assetsMgr.SHIP;
				}
				else if (isChong)
				{
					frame1 = AssetsManager.assetsMgr.CHONG;
					frame2 = AssetsManager.assetsMgr.CHONG;
				}
				else
				{
					frame1 = AssetsManager.assetsMgr.WAR1_R;
					frame2 = AssetsManager.assetsMgr.WAR2_R;
				}
			}
			
			showBlood();
			if (!swfTimer.hasEventListener(TimerEvent.TIMER))
				swfTimer.addEventListener(TimerEvent.TIMER, onTimer);
			swfTimer.start(); 
		}
		
		private function onTimer(evt:TimerEvent):void
		{
			if (frameIndex == 0)
			{
				swfLoad.setStyle("backgroundImage", frame1);
				frameIndex = 1;
			}
			else if (frameIndex == 1)
			{
				swfLoad.setStyle("backgroundImage", frame2);
				frameIndex = 0;
			}
			
			swfLoad.setStyle("backgroundSize", "100%");
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
		
		public function get gameArmy():Army
		{
			return _gameArmy;
		}
		
		public function set gameArmy(param:Army):void
		{
			_gameArmy = param;
			
			var generalID:int = _gameArmy.generalID;
			if (generalID > 0)
				gameGeneral = GameManager.gameMgr.generalList.getObjByID(generalID) as General;
		}
		
		public function get gameGeneral():General
		{
			return _gameGeneral;
		}
		
		public function set gameGeneral(param:General):void
		{
			_gameGeneral = param;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(param:Boolean):void
		{
			_selected = param;
			
			showState();
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
		
		public function get isWar():Boolean
		{
			return _isWar;
		}
		
		public function set isWar(param:Boolean):void
		{
			_isWar = param;
		}
		
		public function get armyState():int
		{
			return _armyState;
		}
		
		public function set armyState(param:int):void
		{
			_armyState = param;
			
			showState();
		}
		
		public function get isNavy():Boolean
		{
			return _isNavy;
		}
		
		public function set isNavy(param:Boolean):void
		{
			_isNavy = param;
		}
		
		public function get isChong():Boolean
		{
			return _isChong;
		}
		
		public function set isChong(param:Boolean):void
		{
			_isChong = param;
		}
		
		public function get isInSea():Boolean
		{
			return _isInSea;
		}
		
		public function set isInSea(param:Boolean):void
		{
			if (param != _isInSea)
			{
				_isInSea = param;
				showState();
			}
		}
		
		public function get isSelf():Boolean
		{
			if (gameGeneral != null)
			{
				var userID:int = gameGeneral.userID;
				if (userID == GameManager.gameMgr.userID)
					_isSelf = true;
				else
					_isSelf = false;
			}
			
			return _isSelf;
		}
		
		public function set isSelf(param:Boolean):void
		{
			_isSelf = param;
		}
		
		public function get isSameSpere():Boolean
		{
			var sphereID:int = 0;
			sphereID = GameManager.gameMgr.wubao.sphereID;
			if (sphereID <= 0) return false;
			
			if (gameGeneral == null) return false;
			
			var userID:int = gameGeneral.userID;
			if (userID <= 0)
				return false;
				
			var gameSphere:Sphere = GameManager.gameMgr.sphereList.getObjByID(sphereID) as Sphere;
			if (gameSphere != null)
			{
				if (gameSphere.userList.hasObj(userID))
					_isSameSpere = true;
				else
					_isSameSpere = false;
			}
			
			return _isSameSpere;
		}
		
		public function set isSameSpere(param:Boolean):void
		{
			_isSameSpere = param;
		}
		
		public function get isAlli():Boolean
		{
			var selfID:int = 0;
			selfID = GameManager.gameMgr.wubao.sphereID;
			if (selfID <= 0) return false;
			
			if (gameGeneral == null) return false;
			
			var userID:int = gameGeneral.userID;
			if (userID <= 0)
				return false;
				
			var gameUser:User = GameManager.gameMgr.userList.getObjByID(userID) as User;
			var sphereID:int = gameUser.sphereID;
			
			if (GameManager.gameMgr.dipList.isAlli(selfID, sphereID))
				_isAlli = true;
			else
				_isAlli = false;
			
			return _isAlli;
		}
		
		public function set isAlli(param:Boolean):void
		{
			_isAlli = param;
		}
		
		public function get isEne():Boolean
		{
			var selfID:int = 0;
			selfID = GameManager.gameMgr.wubao.sphereID;
			if (selfID <= 0) return false;
			
			if (gameGeneral == null) return false;
			
			var userID:int = gameGeneral.userID;
			if (userID <= 0)
				return false;
				
			var gameUser:User = GameManager.gameMgr.userList.getObjByID(userID) as User;
			var sphereID:int = gameUser.sphereID;
			
			if (GameManager.gameMgr.dipList.isEne(selfID, sphereID))
				_isEne = true;
			else
				_isEne = false;
			
			return _isEne;
		}
		
		public function set isEne(param:Boolean):void
		{
			_isEne = param;
		}
		
	}
}