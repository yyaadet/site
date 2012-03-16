package map.list
{
	import flash.utils.ByteArray;
	
	import map.MapUtil;
	
	/**
	 * 地图切片对象列表类 
	 * @author StarX
	 * 
	 */	
	public class MapSliceList
	{
		//上一次加载的切片序列
		private var mapSliceListOld:Array = null;
		
		//本次加载的切片序列
		private var mapSliceListNew:Array = null;
		
		//需要移除的切片序列
		private var _mapRemoveSliceList:Array = null; 
		
		public function MapSliceList()
		{
			if (mapSliceListOld == null)
				mapSliceListOld = new Array();
				
			if (mapSliceListNew == null)
				mapSliceListNew = new Array();
		}
		
		//============================================================
		//公共函数
		//============================================================
		
		/**
		 * 获取将要加载的切片序列组 
		 * @param sliceX
		 * @param sliceY
		 * @param lap
		 * @return 
		 * 
		 */		
		public function getSliceList(sliceX:int, sliceY:int, lap:int):Array
		{
			if (sliceX < 0 || sliceY < 0) return null;
			
			var ret:Array = new Array();
		    
		    //计算切片周围的切片序列
		    getSliceListByLap(sliceX, sliceY, lap);
		    if (mapSliceListNew == null || mapSliceListNew.length < 1) return null;
		    
		    //计算需要加载的切片
			var i:int = 0;
		    for(i = 0; i < mapSliceListNew.length;i++)
		    {
		        if (isSliceExist(mapSliceListNew[i], mapSliceListOld))
			    	continue;
			    
			    var obj:Object = new Object();
			    obj.mapX = mapSliceListNew[i].mapX;
			    obj.mapY = mapSliceListNew[i].mapY;
			    
			    ret.push(obj);
			}
			
			//计算需要移除的切片
			_mapRemoveSliceList = getRemoveMapList();
			   
		    //复制mapSliceListNew数组到mapSliceListOld中,以便下次计算
		    var bytes:ByteArray = new ByteArray();
		    bytes.writeObject(mapSliceListNew);
		    bytes.position = 0;
		    mapSliceListOld.length = 0;
		    mapSliceListOld = bytes.readObject();
		    
			return ret;
		}
		
		//============================================================
		//私有函数
		//============================================================
		
		/**
		 * 根据切片以及圈数，计算出要加载的切片序列组，如果是1圈就是3*3，2圈是5*5 
		 * @param sliceX
		 * @param sliceY
		 * @param count
		 * 
		 */		
		private function getSliceListByLap(sliceX:int, sliceY:int, lap:int):void
		{
			var index:int = 0;
			var i:int = 0;
			var j:int = 0;
			var row:int = 0;
			var x1:int = 0;
			var y1:int = 0;
		         
		    mapSliceListNew.length = 0;
			
			for(index = 0; index <= lap; index++)
			{
				row = (index * 2  + 1);
				
				for(i = 0; i < row; i++)
				{
				    for(j = 0; j < row; j++)
				    {
						x1 = sliceX + i - index;
						y1 = sliceY + index - j;
						
						//如果超过地图边界不需要加载
						if (x1 < 0 || x1 > MapUtil.mapRow - 1 || y1 < 0 || y1 > MapUtil.mapCol - 1) continue;
				
						var obj:Object = new Object();
						obj.mapX = MapUtil.mapValue(x1);
						obj.mapY = MapUtil.mapValue(y1);
						
						if (!isSliceExist(obj, mapSliceListNew))
							mapSliceListNew.push(obj);
				    }
				}
			}
		
		}
		
		/**
		 * 判断切片是否已加载过 
		 * @param obj
		 * @param mapSliceList
		 * @return 
		 * 
		 */		
		private function isSliceExist(obj:Object, mapSliceList:Array):Boolean
		{
		    var ret:Boolean = false;
		
		    for(var i:int = 0; i < mapSliceList.length; i++)
		    {
		        if (obj.mapX == mapSliceList[i].mapX && obj.mapY == mapSliceList[i].mapY)
			    	return true
		    }
		
		    return ret;
		}
		
		/**
		 * 获取需要移除的地图切片 
		 * @return 
		 * 
		 */		
		private function getRemoveMapList():Array
		{
			if (mapSliceListNew == null || mapSliceListNew.length < 1) return null;
			if (mapSliceListOld == null || mapSliceListOld.length < 1) return null;
			
			var ret:Array = new Array();
			
		    for(var i:int = 0; i < mapSliceListOld.length;i++)
		    {
		        if ( !isSliceExist(mapSliceListOld[i], mapSliceListNew) )
				{
				    var obj:Object = new Object();
				    obj.mapX = mapSliceListOld[i].mapX;
				    obj.mapY = mapSliceListOld[i].mapY;
				    
					ret.push(obj);
				}
		    }
		    
		    return ret;
		}
		
		//======================================================================
		//属性
		//======================================================================
		
		public function get mapRemoveSliceList():Array
		{
			return _mapRemoveSliceList;
		}
		
		public function get mapSliceNew():Array
		{
			return mapSliceListNew;
		}
		
	}
}