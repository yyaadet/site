package wubao.list
{
	import utils.list.GameList;
	
	import wubao.model.Transfer;

	/**
	 * 输送指令列表 
	 * @author bxl
	 * 
	 */	
	public class TranList extends GameList
	{
		public function TranList()
		{
			super();
		}
		
		/**
		 * 获取输送武将的指令 
		 * @param generalID
		 * @return 
		 * 
		 */		
		public function getByGeneralID(generalID:int):Transfer
		{
			var i:int = 0;
			var len:int = 0;
			var trans:Transfer = null;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				trans = getObjByIndex(i) as Transfer;
				if (trans != null && trans.objType == 1 && trans.objID == generalID)
					return trans;
			}
			
			return null;
		}
		
		public function removeByGeneralID(generalID:int):void
		{
			var i:int = 0;
			var len:int = 0;
			var trans:Transfer = null;
			
			len = this.length;
			for (i = 0; i < len; i++)
			{
				trans = getObjByIndex(i) as Transfer;
				if (trans != null && trans.objType == 1 && trans.objID == generalID)
					removeObjByID(trans.uniqID);
			}
		}
	}
}