package guid
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import images.AssetsManager;
	
	import mx.containers.Canvas;
	import mx.controls.SWFLoader;
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import net.tcp.TcpManager;
	import net.tcp.model.TcpGuid;
	
	import utils.GameManager;
	import utils.PubUnit;
	import utils.SceneManager;
	import utils.WinManager;
	import utils.components.GameButton;
	
	public class GuidManager
	{
		private static var _guidMgr:GuidManager = null;
		
		private var hf:hanfeng;
		
		//背景
		private var mask:UIComponent = null;
		
		//红色方框的边框宽度
		private var borderW:int = 3;
		//可点击红色方框
		private var block:UIComponent = null;
		private var blockX:int = 0;
		private var blockY:int = 0;
		private var blockW:int = 0;
		private var blockH:int = 0; 
		
		//不可点击红色方框
		private var block1:UIComponent = null;
		private var block1X:int = 0;
		private var block1Y:int = 0;
		private var block1W:int = 0;
		private var block1H:int = 0; 
		
		//提示信息
		private var taInfo:TextArea = null;
		//提示信息边框
		private var cvInfo:Canvas = null;
		
		//指引动画
		private var swfLoader:SWFLoader = null;
		
		//新手指引mm头像
		private var guidFace:Canvas = null;
		
		//跳过指引按钮
		private var btnSkip:GameButton = null;
		
		//背景
		private	var bgColor:int = 0x333333;
		private	var bgAlpha:Number = 0.3;
		
		//当前函数索引
		private var _funcIndex:int = 0;
		private var func:Function = null;
		
		//指引提示信息
		private var showInfo:String = "";
		private var showInfoIndex:int = 0;
		private var timer1:Timer = new Timer(50);
		
		//是否可以任意点击继续
		private var canClick:Boolean = false;
		
		//函数顺序
		private var funcList:Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,
		                              31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,80,53,54,55,56,57,
		                              58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79];
		
		public function GuidManager()
		{
			if(_guidMgr != null)
				throw new Error("不能多次创建guidMangager的实例!");
		}
		
		/**
		 * 管理器初始化 
		 * 
		 */		
		public static function init():void
		{
			if (_guidMgr == null)
				_guidMgr = new GuidManager();
		}
		
		/**
		 * 获取管理器单例 
		 * @return 
		 * 
		 */		
		public static function get guidMgr():GuidManager
		{
			return _guidMgr;
		}
		
		public function initUI():void
		{
			hf = GameManager.gameMgr.gameApp;
			
			if (mask == null)
			{
				mask = new UIComponent();
				mask.x = 0;
				mask.y = 0;
				mask.width = hf.width;
				mask.height = hf.height;
				WinManager.winMgr.popWindowCenter(mask);
			}
			
			if (block == null)
			{
				block = new UIComponent();
				block.x = 0;
				block.y = 0;
				mask.addChild(block);
				block.visible = false;
				block.includeInLayout = false;
			}
			
			if (block1 == null)
			{
				block1 = new UIComponent();
				block1.x = 0;
				block1.y = 0;
				mask.addChild(block1);
				block1.visible = false;
				block1.includeInLayout = false;
			}
			
			if (cvInfo == null)
			{
				cvInfo = new Canvas();
				cvInfo.x = 0;
				cvInfo.y = 0;
				cvInfo.width = 254;
				cvInfo.height = 96;
				mask.addChild(cvInfo);
				cvInfo.setStyle("borderStyle", "solid");
				cvInfo.setStyle("borderThickness", 2);
				cvInfo.setStyle("borderColor", 0x5C6717);
				cvInfo.setStyle("cornerRadius", 5);
				cvInfo.setStyle("backgroundColor", 0x434A0C);
				cvInfo.setStyle("backgroundAlpha", 0);
			}
			
			if (taInfo == null)
			{
				taInfo = new TextArea();
				taInfo.x = 0;
				taInfo.y = 0;
				taInfo.width = 250;
				taInfo.height = 92;
				taInfo.setStyle("color", PubUnit.WHITE);
				taInfo.setStyle("fontSize", 14);
				taInfo.setStyle("backgroundAlpha", 0.5);
				cvInfo.addChild(taInfo);
			}
			
			if (swfLoader == null)
			{
				swfLoader = new SWFLoader();
				swfLoader.x = 0;
				swfLoader.y = 0;
				swfLoader.width = 19;
				swfLoader.height = 21;
				mask.addChild(swfLoader);
				swfLoader.autoLoad = true;
				swfLoader.source = AssetsManager.assetsMgr.MAIN_GUID;
			}
			
			if (guidFace == null)
			{
				guidFace = new Canvas();
				guidFace.width = 96;
				guidFace.height = 96;
				guidFace.x = 0;
				guidFace.y = 0;
				mask.addChild(guidFace);
				guidFace.setStyle("backgroundImage", AssetsManager.assetsMgr.MAIN_GUID_FACE);
			}
			
			if (btnSkip == null)
			{
				btnSkip = new GameButton();
				btnSkip.width = 80;
				btnSkip.height = 24;
				btnSkip.x = (mask.width - btnSkip.width) / 2;
				btnSkip.y = mask.height - 50;
				btnSkip.label = "跳过指引";
				mask.addChild(btnSkip);
				btnSkip.addEventListener(MouseEvent.CLICK, skipClick);
			}
			
			mask.addEventListener(MouseEvent.CLICK, onClick);
			timer1.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function skipClick(evt:MouseEvent):void
		{
			GameManager.gameMgr.isShowGuid = false;
			mask.visible = false;
			mask.includeInLayout = false;
			saveIndex(1000);
			evt.stopPropagation();
		}
		
		private function onClick(evt:MouseEvent):void
		{
			if (timer1.running) return;
			if (!canClick) return;
			
			gotoNext();
		}
		
		private function onTimer(evt:TimerEvent):void
		{
			if (showInfoIndex == showInfo.length)
			{
				showInfoIndex = 0;
				timer1.stop();
				return;
			}
			
			taInfo.text += showInfo.charAt(showInfoIndex);
			showInfoIndex ++;  
		}
		
		private function playGuidSwf():void
		{
			swfLoader.visible = true;
			swfLoader.includeInLayout = true;
			var mc:MovieClip = swfLoader.content as MovieClip;
			if (mc != null)
				mc.play();
		}
		
		private function stopGuidSwf():void
		{
			swfLoader.visible = false;
			swfLoader.includeInLayout = false;
			var mc:MovieClip = swfLoader.content as MovieClip;
			if (mc != null)
				mc.stop();
		}
		
		private function posTextArea(isCenter:Boolean, offX:int = 0, offY:int = 0):void
		{
			var centerX:int = 0;
			var centerY:int = 0;
			
			centerX = int((mask.width - cvInfo.width) / 2);
			centerY = int((mask.height - cvInfo.height) / 2)
			if (isCenter)
			{
				cvInfo.x = centerX;
				cvInfo.y = centerY;
			}
			else
			{
				cvInfo.x = centerX - offX;
				cvInfo.y = centerY - offY;
			}
			
			guidFace.x = cvInfo.x - guidFace.width - 5;
			guidFace.y = cvInfo.y;
		}
		
		/**
		 *  
		 * @param hasBlock  可点击红色方框
		 * @param hasBlock1 不可点击红色方框
		 * 
		 */		
		private function show(hasBlock:Boolean, hasBlock1:Boolean = false):void
		{
			mask.graphics.clear();
			
			if (!hasBlock)
			{
				mask.graphics.beginFill(bgColor, bgAlpha);
				mask.graphics.drawRect(0, 0, mask.width, mask.height);
				mask.graphics.endFill();
			}
			else
			{
				//上
				mask.graphics.beginFill(bgColor, bgAlpha);
				mask.graphics.drawRect(0, 0, mask.width, blockY);
				mask.graphics.endFill();
				
				//左
				mask.graphics.beginFill(bgColor, bgAlpha);
				mask.graphics.drawRect(0, blockY, blockX, blockH);
				mask.graphics.endFill();
				
				//右
				mask.graphics.beginFill(bgColor, bgAlpha);
				mask.graphics.drawRect(blockX + blockW, blockY, mask.width - blockY - blockW, blockH);
				mask.graphics.endFill();
				
				//下
				mask.graphics.beginFill(bgColor, bgAlpha);
				mask.graphics.drawRect(0, blockY + blockH, mask.width, mask.height - blockY - blockH);
				mask.graphics.endFill();
			}
			
			mask.visible = true;
			mask.includeInLayout = true;
			PopUpManager.bringToFront(mask);
			
			//
			if (hasBlock)
			{
				block.visible = true;
				block.includeInLayout = true;
				block.x = blockX;
				block.y = blockY;
				block.width = blockW + borderW * 2;
				block.height = blockH + borderW * 2;
				
				block.graphics.clear();
				
				block.graphics.beginFill(PubUnit.RED);
				block.graphics.drawRect(0, 0, block.width, borderW);
				block.graphics.endFill();
				
				block.graphics.beginFill(PubUnit.RED);
				block.graphics.drawRect(block.width - borderW, 0, borderW, block.height);
				block.graphics.endFill();
				
				block.graphics.beginFill(PubUnit.RED);
				block.graphics.drawRect(0, block.height - borderW, block.width, borderW);
				block.graphics.endFill();
				
				block.graphics.beginFill(PubUnit.RED);
				block.graphics.drawRect(0, 0, borderW, block.height);
				block.graphics.endFill();
			
				swfLoader.x = block.x + (block.width - swfLoader.width) / 2;
				swfLoader.y = block.y - swfLoader.height + 3;
				playGuidSwf();
			}
			else
			{
				block.visible = false;
				block.includeInLayout = false;
				stopGuidSwf();
			}
			
			//
			if (hasBlock1)
			{
				block1.visible = true;
				block1.includeInLayout = true;
				block1.x = block1X;
				block1.y = block1Y;
				block1.width = block1W + borderW * 2;
				block1.height = block1H + borderW * 2;
				
				block1.graphics.clear();
				
				block1.graphics.beginFill(PubUnit.RED);
				block1.graphics.drawRect(0, 0, block1.width, borderW);
				block1.graphics.endFill();
				
				block1.graphics.beginFill(PubUnit.RED);
				block1.graphics.drawRect(block1.width - borderW, 0, borderW, block1.height);
				block1.graphics.endFill();
				
				block1.graphics.beginFill(PubUnit.RED);
				block1.graphics.drawRect(0, block1.height - borderW, block1.width, borderW);
				block1.graphics.endFill();
				
				block1.graphics.beginFill(PubUnit.RED);
				block1.graphics.drawRect(0, 0, borderW, block1.height);
				block1.graphics.endFill();
			}
			else
			{
				block1.visible = false;
				block1.includeInLayout = false;
			}
			
		}
		
		public function hideGuid():void
		{
			mask.visible = false;
			mask.includeInLayout = false;
		}
		
		public function saveIndex(index:int):void
		{
			var tcpGuid:TcpGuid = new TcpGuid();
			tcpGuid.guidIndex = index;
			TcpManager.tcpMgr.sendGuid(tcpGuid);
		}
		
		public function gotoNext():void
		{
			if (!GameManager.gameMgr.isShowGuid) return;
			
			funcIndex ++;
			func = this["func" + funcList[funcIndex].toString()];
			func();
		}
		
		public function gotoIndex(index:int):void
		{
			funcIndex = index;
			func = this["func" + funcList[funcIndex].toString()];
			func();
		}
		
		private function func1():void
		{
			mask.visible = true;
			mask.includeInLayout = true;
			
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "恭喜【" + GameManager.gameMgr.user.userName + "】，你已经拥有了自己的坞堡，接下来您需要了解一下如何发展坞堡和带兵打仗\n(任意点击继续)";
			posTextArea(true);
			timer1.start();
		}
		
		private function func2():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "首先我们来了解下如何做任务和攻打战役\n(任意点击继续)";
			posTextArea(true);
			timer1.start();
		}
		
		private function func3():void
		{
			blockW = 35;
			blockH = 35;
			blockX = hf.panelMenu.x + 106;
			blockY = hf.panelMenu.y;
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "完成任务会有丰富的资源奖励，点击右下角的“任务”按钮，开启任务界面";
			posTextArea(true);
			timer1.start();
		}
		
		private function func4():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winTask.x + 463; 
			blockY = WinManager.winMgr.winTask.y + 362;
			
			block1W = 94;
			block1H = 28;
			block1X = WinManager.winMgr.winTask.x + 20; 
			block1Y = WinManager.winMgr.winTask.y + 75;
			canClick = false;
			show(true, true);
			taInfo.text = "";
			showInfo = "请接收“攻击黄巾”任务";
			posTextArea(false, -385, -250);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func5():void
		{
			saveIndex(funcIndex);
			
			blockW = 19;
			blockH = 19;
			blockX = WinManager.winMgr.winTask.x + 512; 
			blockY = WinManager.winMgr.winTask.y + 3;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "接着我们去完成这个任务（请先关闭任务界面）";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func6():void
		{
			blockW = 48;
			blockH = 45;
			blockX = hf.panelDate.x + 146; 
			blockY = hf.panelDate.y + 27;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击左上角的“战役”按钮，切换到战役场景";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func7():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "在战役场景中，您可以攻打NPC，并获得一些功勋以及工坊中无法生产的特殊装备\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func8():void
		{
			blockW = 72;
			blockH = 72;
			blockX = SceneManager.sceneMgr.sceneBattle.battleBG.x + 380;
			blockY = SceneManager.sceneMgr.sceneBattle.battleBG.y + 346;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击图标，打开关卡界面";
			posTextArea(false, -10, 0);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func9():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winGate.x + 252;
			blockY = WinManager.winMgr.winGate.y + 41;
			
			block1W = 48;
			block1H = 48;
			block1X = WinManager.winMgr.winGate.x + 18; 
			block1Y = WinManager.winMgr.winGate.y + 245;
			
			canClick = false;
			show(true, true);
			taInfo.text = "";
			showInfo = "请点击“攻击”按钮";
			posTextArea(false, -185, 50);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func10():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "恭喜主公首战告捷，剿灭了黄巾前哨\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func11():void
		{
			block1W = 52;
			block1H = 24;
			block1X = hf.panelTip.x;
			block1Y = hf.panelTip.y - 2;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "每次战斗消耗一个军令，每天40个军令，系统每天会自动恢复军令到40个\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func12():void
		{
			block1W = 112;
			block1H = 20;
			block1X = hf.panelQuene.x;
			block1Y = hf.panelQuene.y - 6;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "每次战斗后需要休息一段时间才能继续战斗\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func13():void
		{
			blockW = 35;
			blockH = 35;
			blockX = hf.panelMenu.x + 106;
			blockY = hf.panelMenu.y;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "任务“攻击黄巾”已完成，现在让我们去领取任务奖励,请点击右下角的“任务”按钮";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func14():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winTask.x + 463; 
			blockY = WinManager.winMgr.winTask.y + 362;
			
			block1W = 94;
			block1H = 28;
			block1X = WinManager.winMgr.winTask.x + 20; 
			block1Y = WinManager.winMgr.winTask.y + 75;
			canClick = false;
			show(true, true);
			taInfo.text = "";
			showInfo = "请点击“领取奖励”按钮，领取任务奖励";
			posTextArea(false, -385, -250);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func15():void
		{
			saveIndex(funcIndex);
			
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "任务和战斗指导结束\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func16():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "接下来我们来了解下如何升级建筑\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func17():void
		{
			blockW = 48;
			blockH = 45;
			blockX = hf.panelDate.x + 96; 
			blockY = hf.panelDate.y + 40;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "让我们先返回坞堡场景，请点击左上角的“坞堡”按钮";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func18():void
		{
			blockW = 150;
			blockH = 125;
			blockX = hf.swb.cvBG.x + 590; 
			blockY = hf.swb.cvBG.y + 262;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击议事堂";
			posTextArea(false, 0, -87);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func19():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winYst.x + 405; 
			blockY = WinManager.winMgr.winYst.y + 175;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击“升级”按钮";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func20():void
		{
			saveIndex(funcIndex);
			
			block1W = 112;
			block1H = 20;
			block1X = hf.panelQuene.x;
			block1Y = hf.panelQuene.y + 55;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "升级建筑需要等待一段时间才能完成\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func21():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "议事堂等级代表您的等级，提升议事堂等级后才能升级其他的建筑\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func22():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "升级建筑指导完成\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func23():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "要想击败更强大的敌人，需要不断提升战斗实力。接下来我们了解下有哪些方法可以提升战斗实力\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func24():void
		{
			blockW = 48;
			blockH = 48;
			blockX = hf.panelOperate.x - 2;
			blockY = hf.panelOperate.y + 3 * 48 - 2;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "首先训练武将，提升武将的等级可以加强战斗实力，请点击右侧的“训练”按钮";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func25():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winTrain.x + 314;
			blockY = WinManager.winMgr.winTrain.y + 38;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击“训练”";
			posTextArea(false, 20, 150);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func26():void
		{
			saveIndex(funcIndex);
			
			block1W = 112;
			block1H = 20;
			block1X = hf.panelQuene.x;
			block1Y = hf.panelQuene.y + 17;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "恭喜，您的部下已经升到1级，每次训练后要等待一段时间后才能继续训练\n注：武将等级不能超过议事堂等级\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func27():void
		{
			blockW = 35;
			blockH = 35;
			blockX = hf.panelMenu.x + 24;
			blockY = hf.panelMenu.y;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "训练指导结束，接下来我们了解如何让武将学习阵法,请点击右下角的“武将”按钮，开启武将列表界面";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func28():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winGenList.x + 217;
			blockY = WinManager.winMgr.winGenList.y + 327;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击“学习”按钮";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func29():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "在学习阵法之前，我们先了解下10个阵法的特点以及用处\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func30():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 7;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "锥形阵：攻击 +75%，机动 +25%（骑兵专用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func31():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 54;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "鹤翼阵：攻击 +75%，防御 +25%（弩兵专用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func32():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 101;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "鱼鳞阵：攻击 +25%，防御 +75%（步兵专用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func33():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 147;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "雁行阵：防御 +75%，机动 +25%（弩骑兵专用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func34():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 193;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "锋矢阵：攻击 +100%（步兵和骑兵专用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func35():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 238;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "长蛇阵：机动 +100%（所有兵种适用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func36():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 284;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "衡轭阵：攻击 +50%，防御 +50%（所有兵种适用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func37():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 330;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "箕形阵：防御 +50%，机动 +50%（所有兵种适用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func38():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 376;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "偃月阵：攻击 +50%，机动 +50%（所有兵种适用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func39():void
		{
			block1W = 44;
			block1H = 18;
			block1X = WinManager.winMgr.winStudy.x + 422;
			block1Y = WinManager.winMgr.winStudy.y + 137;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "方圆阵：防御 +100%（所有兵种适用）\n(任意点击继续)";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func40():void
		{
			blockW = 44;
			blockH = 18;
			blockX = WinManager.winMgr.winStudy.x + 284;
			blockY = WinManager.winMgr.winStudy.y + 137;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "10个阵法已经介绍完毕，下面我们来了解如何学习衡轭阵，请点击“衡轭”按钮";
			posTextArea(false, 0, -127);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func41():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winAsk.x + 79;
			blockY = WinManager.winMgr.winAsk.y + 92;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击“确定”按钮";
			posTextArea(false, 0, -115);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func42():void
		{
			saveIndex(funcIndex);
			WinManager.winMgr.winGenList.visible = false;
			WinManager.winMgr.winGenList.includeInLayout = false;
			WinManager.winMgr.winStudy.visible = false;
			WinManager.winMgr.winStudy.includeInLayout = false;
			
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "学习阵法指导完成，技能的学习与阵法一样。学习阵法和技能都要耗费玩家的功勋值，功勋可在战役中获得。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func43():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "工欲善其事，必先利其器。想在乱世中争锋，士兵没有好的装备怎么行？下面我们来了解如何生产兵装\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func44():void
		{
			blockW = 100;
			blockH = 50;
			blockX = hf.swb.cvBG.x + 480; 
			blockY = hf.swb.cvBG.y + 372;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击工坊，开启工坊界面";
			posTextArea(false, 0, -125);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func45():void
		{
			blockW = 40;
			blockH = 20;
			blockX = WinManager.winMgr.winFactory.x + 298; 
			blockY = WinManager.winMgr.winFactory.y + 61;
			
			block1W = 100;
			block1H = 20;
			block1X = WinManager.winMgr.winFactory.x + 147; 
			block1Y = WinManager.winMgr.winFactory.y + 62;
			
			canClick = false;
			show(true, true);
			taInfo.text = "";
			showInfo = "请点击最大按钮";
			posTextArea(false, 0, -75);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func46():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winFactory.x + 408; 
			blockY = WinManager.winMgr.winFactory.y + 36;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击“生产”按钮";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func47():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winAsk.x + 79;
			blockY = WinManager.winMgr.winAsk.y + 92;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击“确定”按钮";
			posTextArea(false, 0, -115);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func48():void
		{
			saveIndex(funcIndex);
			
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "兵装生产成功，接下来我们了解如何给武将装备兵装\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func49():void
		{
			blockW = 35;
			blockH = 35;
			blockX = hf.panelMenu.x + 24;
			blockY = hf.panelMenu.y;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击右下角的“武将”按钮，开启武将界面";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func50():void
		{
			blockW = 160;
			blockH = 20;
			blockX = WinManager.winMgr.winGenList.x + 243;
			blockY = WinManager.winMgr.winGenList.y + 34;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击“士兵装备”,切换到装备界面";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func51():void
		{
			blockW = 35;
			blockH = 20;
			blockX = WinManager.winMgr.winGenList.x + 220;
			blockY = WinManager.winMgr.winGenList.y + 70;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请在兵力输入框中输入130";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func52():void
		{
			blockW = 48;
			blockH = 48;
			blockX = WinManager.winMgr.winGenList.x + 334;
			blockY = WinManager.winMgr.winGenList.y + 107;
			
			block1W = 48;
			block1H = 48;
			block1X = WinManager.winMgr.winGenList.x + 109;
			block1Y = WinManager.winMgr.winGenList.y + 133;
			
			canClick = false;
			show(true, true);
			taInfo.text = "";
			showInfo = "点击图标给士兵重新装备兵装";
			posTextArea(false, 0, -60);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func80():void
		{
			blockW = 60;
			blockH = 20;
			blockX = WinManager.winMgr.winGenList.x + 380;
			blockY = WinManager.winMgr.winGenList.y + 71;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请选择衡轭阵";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func53():void
		{
			blockW = 63;
			blockH = 24;
			blockX = WinManager.winMgr.winGenList.x + 488;
			blockY = WinManager.winMgr.winGenList.y + 68;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击“确定”按钮完成配兵操作";
			posTextArea(false, -400, 0);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func54():void
		{
			saveIndex(funcIndex);
			WinManager.winMgr.winGenList.visible = false;
			WinManager.winMgr.winGenList.includeInLayout = false;
			
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "配兵指导结束，在攻打下一个战役关卡之前先让我们了解下如何治疗伤兵\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func55():void
		{
			blockW = 80;
			blockH = 45;
			blockX = hf.swb.cvBG.x + 815; 
			blockY = hf.swb.cvBG.y + 380;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击医馆，开启医馆界面";
			posTextArea(false, 45, -75);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func56():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winHospital.x + 408; 
			blockY = WinManager.winMgr.winHospital.y + 37;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击“治疗”按钮";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func57():void
		{
			saveIndex(funcIndex);
			WinManager.winMgr.winHospital.visible = false;
			WinManager.winMgr.winHospital.includeInLayout = false;
			
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "治疗伤兵指导结束\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func58():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "接下来我们来了解坞堡中其他建筑的用途\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func59():void
		{
			block1W = 125;
			block1H = 70;
			block1X = hf.swb.cvBG.x + 426; 
			block1Y = hf.swb.cvBG.y + 440;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "民居是坞堡内居民居住之所，升级民居可提高居住上限。农田等资源产地和工坊的等级也受限于民居的等级。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func60():void
		{
			block1W = 104;
			block1H = 75;
			block1X = hf.swb.cvBG.x + 455; 
			block1Y = hf.swb.cvBG.y + 294;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "库房是中存放的是您生产的兵装，在这里您可以对兵装进行强化，出售和回收。\n(任意点击继续)";
			posTextArea(false, 0, -70);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func61():void
		{
			blockW = 73;
			blockH = 114;
			blockX = hf.swb.cvBG.x + 750; 
			blockY = hf.swb.cvBG.y + 255;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "书院是坞堡研究科技的建筑，请点击书院查看详细信息。";
			posTextArea(false, 0, -70);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func62():void
		{
			block1W = 230;
			block1H = 20;
			block1X = WinManager.winMgr.winSchool.x + 10; 
			block1Y = WinManager.winMgr.winSchool.y + 34;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "升级装备科技可强化装备的相应等级。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func63():void
		{
			block1W = 230;
			block1H = 20;
			block1X = WinManager.winMgr.winSchool.x + 244; 
			block1Y = WinManager.winMgr.winSchool.y + 34;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "升级资源科技可提高相应资源的产量。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func64():void
		{
			WinManager.winMgr.winSchool.visible = false;
			WinManager.winMgr.winSchool.includeInLayout = false;
			
			block1W = 180;
			block1H = 80;
			block1X = hf.swb.cvBG.x + 845; 
			block1Y = hf.swb.cvBG.y + 425;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "军营自动募集步卒，升级军营可提升募集上限以及训练武将所获得经验值。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func65():void
		{
			block1W = 133;
			block1H = 107;
			block1X = hf.swb.cvBG.x + 230; 
			block1Y = hf.swb.cvBG.y + 424;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "客栈中可招募武将。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func66():void
		{
			block1W = 202;
			block1H = 85;
			block1X = hf.swb.cvBG.x + 1019; 
			block1Y = hf.swb.cvBG.y + 406;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "集市生产的资源是钱币，每月月初交纳。升级集市可提升钱币产量。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func67():void
		{
			block1W = 255;
			block1H = 100;
			block1X = hf.swb.cvBG.x + 1111; 
			block1Y = hf.swb.cvBG.y + 280;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "农田生产的资源是粮食，每年九月初交纳。升级农田可提升粮食产量。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func68():void
		{
			block1W = 135;
			block1H = 75;
			block1X = hf.swb.cvBG.x + 936; 
			block1Y = hf.swb.cvBG.y + 300;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "牧场生产的资源是马匹，每月月初交纳。升级牧场可提升马匹产量。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func69():void
		{
			block1W = 125;
			block1H = 62;
			block1X = hf.swb.cvBG.x + 315; 
			block1Y = hf.swb.cvBG.y + 278;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "伐木场生产的资源是木料，每月月初交纳。升级伐木场可提升木料产量。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func70():void
		{
			block1W = 113;
			block1H = 83;
			block1X = hf.swb.cvBG.x + 318; 
			block1Y = hf.swb.cvBG.y + 372;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "革坊生产的资源是皮革，每月月初交纳。升级革坊可提升皮革产量。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func71():void
		{
			block1W = 217;
			block1H = 156;
			block1X = hf.swb.cvBG.x; 
			block1Y = hf.swb.cvBG.y + 275;
			
			canClick = true;
			show(false, true);
			taInfo.text = "";
			showInfo = "矿山生产的资源是矿石，每月月初交纳。升级矿山可提升矿石产量。\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func72():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "坞堡中的建筑介绍完毕\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func73():void
		{
			blockW = 48;
			blockH = 45;
			blockX = hf.panelDate.x + 146; 
			blockY = hf.panelDate.y + 27;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "接下来让我们去攻打战役中第二个关卡,请点击左上角的“战役”按钮，切换到战役场景";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func74():void
		{
			blockW = 70;
			blockH = 70;
			blockX = SceneManager.sceneMgr.sceneBattle.battleBG.x + 440;
			blockY = SceneManager.sceneMgr.sceneBattle.battleBG.y + 306;
			
			canClick = false;
			show(true);
			taInfo.text = "";
			showInfo = "请点击图标，打开关卡界面";
			posTextArea(false, -70, 0);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func75():void
		{
			blockW = 64;
			blockH = 24;
			blockX = WinManager.winMgr.winGate.x + 252;
			blockY = WinManager.winMgr.winGate.y + 42;
			
			block1W = 48;
			block1H = 48;
			block1X = WinManager.winMgr.winGate.x + 18; 
			block1Y = WinManager.winMgr.winGate.y + 245;
			
			canClick = false;
			show(true, true);
			taInfo.text = "";
			showInfo = "请点击“攻击”按钮";
			posTextArea(false, -185, 50);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func76():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "恭喜你击败了黄巾斥候，接下来的路将更加艰辛，让我们正式踏上征程吧\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func77():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "胜败乃兵家常事，如果敌众我寡无法抗敌，可先强化兵装提高战斗力。如果钱粮紧缺，请您升级资源建筑以及资源科技，完成任务也可以获取一些资源奖励\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func78():void
		{
			canClick = true;
			show(false);
			taInfo.text = "";
			showInfo = "新手指引结束，相信您也领悟了如何在乱世中立足。现在黄巾势力猖獗，请您尽快扫灭黄巾，为芸芸众生带来一片安宁吧\n(任意点击继续)";
			posTextArea(true);
			showInfoIndex = 0;
			timer1.start();
		}
		
		private function func79():void
		{
			hideGuid();
			GameManager.gameMgr.isShowGuid = false;
			saveIndex(1000);
			SceneManager.sceneMgr.enterWubao();
		}
		
		
		public function get funcIndex():int
		{
			return _funcIndex;
		}
		
		public function set funcIndex(param:int):void
		{
			_funcIndex = param;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}