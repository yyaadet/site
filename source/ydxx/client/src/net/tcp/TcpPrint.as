package net.tcp
{
	import army.model.Army;
	
	import utils.GameManager;
	
	/**
	 * 打印类，用来在界面的打印板中打印信息 
	 * @author bxl
	 * 
	 */	
	public class TcpPrint
	{
		public function TcpPrint()
		{
		}
		
		/**
		 * 打印军团消息包 
		 * @param index
		 * @param state
		 * @param gameArmy
		 * 
		 */		
		public static function printArmy(index:int, state:int, gameArmy:Army):void
		{
			var stateStr:String = "";
			if (state == 1) stateStr = "正常";
			else if (state == 2) stateStr = "战争";
			else if (state == 3) stateStr = "死亡";
			
			GameManager.gameMgr.gameApp.taTest.text = "index " + index.toString() + "\n" +
			                                          "armyID " + gameArmy.uniqID.toString() + "\n" +
			                                          "generalID " + gameArmy.generalID.toString() + "\n" +
			                                          "state " + stateStr + "\n" +
			                                          "mapX " + gameArmy.mapX.toString() + "\n" +
			                                          "mapY " + gameArmy.mapY.toString() + "\n" +
			                                          "money " + gameArmy.money.toString() + "\n" +
			                                          "food " + gameArmy.food.toString() + "\n" +
			                                          "original " + gameArmy.original.toString() + "\n" +
			                                          "type " + gameArmy.type.toString() + "\n";
			                                          
			var i:int = 0;
			var moveLen:int = 0;
			var moveList:Array = [];
			moveLen = gameArmy.moveList.length;
			GameManager.gameMgr.gameApp.taTest.text += "moveLen " + moveLen.toString() + "\n";
			for(i = 0; i < moveLen; i++)
			{
				moveList[i] = gameArmy.moveList[i];
				
				GameManager.gameMgr.gameApp.taTest.text += "startX " + moveList[i][0].toString() + "\n" +
														   "startY " + moveList[i][1].toString() + "\n" +
														   "endX " + moveList[i][2].toString() + "\n" +
														   "endtX " + moveList[i][3].toString() + "\n" +
														   "time " + moveList[i][4].toString() + "\n";
			}
			                                          
		}
		
		public static function printGeneral(count:int):void
		{
			GameManager.gameMgr.gameApp.taTest.text += count.toString();
		}

	}
}