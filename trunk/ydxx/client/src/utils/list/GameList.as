package utils.list
{
	/**
	 * 列表基类 
	 * @author bxl
	 * 
	 */	
	public class GameList 
	{
		protected var hashMap:HashMap = null;
		
		public function GameList()
		{
			if (hashMap == null)
				hashMap = new HashMap(); 			
		}
		
		public function add(obj:Object):void
		{
			if (hashMap == null) return;
			
			hashMap.put(obj.uniqID, obj);
		}
		
		public function indexOf(uniqID:int):int
		{
			if (hashMap == null) return -1;
			
			return hashMap.indexOf(uniqID);
		}
		
		public function getObjByID(uniqID:int):Object
		{
			if (hashMap == null) return null;
			
			return hashMap.getValue(uniqID);
		}
		
		public function getObjByIndex(index:int):Object
		{
			if (hashMap == null) return null;
			
			return hashMap.getValueByIndex(index);
		}
		
		public function getPageObj(startNum:int, pageNum:int):Array
		{
			var ret:Array = [];
			var i:int = 0;
			var obj:Object;
			var len:int = 0;
			var count:int = 0;
			
			len = this.length;
			
			for (i = 0; i < len; i++)
			{
				obj = getObjByIndex(i);
				if (obj != null && i >= startNum - 1 && count < pageNum)
				{
					ret.push(obj);
					count ++;
				}
			}
			
			return ret;
		}
		public function hasObj(uniqID:int):Boolean
		{
			if (hashMap == null) return false;
			
			return hashMap.containsKey(uniqID);
		}
		
		public function removeObjByID(uniqID:int):void
		{
			if (hashMap == null) return;
			
			hashMap.remove(uniqID);
		}
		
		public function removeAll():void
		{
			if (hashMap == null) return;
			
			hashMap.removeAll();
		}
		
		public function get list():Array
		{
			if (hashMap == null) return null;
			
			return hashMap.values();
		}
		
		public function get length():int
		{
			return hashMap.size();
		}
		
	}
}