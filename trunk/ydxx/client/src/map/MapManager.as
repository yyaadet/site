package map
{
	import city.model.City;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import images.AssetsManager;
	
	import map.list.CityPointList;
	import map.list.MapCityList;
	import map.list.MapSliceList;
	import map.model.CityPoint;
	import map.model.MapCity;
	import map.model.MapFlag;
	import map.model.MapSel;
	import map.model.MapSlice;
	import map.ui.CityMenu;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.SWFLoader;
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	import sphere.list.SphereList;
	import sphere.model.Sphere;
	
	import utils.FormatText;
	import utils.GameManager;
	import utils.PubUnit;
	
	/**
	 * 游戏地图控制 
	 * @author StarX
	 * 
	 */	
	public class MapManager
	{
		private static var _mapMgr:MapManager = null;
		
		//是否已初始化完地图
		private var _isInitMap:Boolean = false;
		
		/**
		 * 构造函数 
		 * 
		 */		
		public function MapManager()
		{
			if (_mapMgr != null)
				throw new Error("不能多次创建mapMangager的实例!");
		}
		
		/**
		 * 管理器初始化 
		 * 
		 */		
		public static function init():void
		{
			if (_mapMgr == null)
				_mapMgr = new MapManager();
		}
		
		/**
		 * 获取管理器单例 
		 * @return 
		 * 
		 */		
		public static function get mapMgr():MapManager
		{
			return _mapMgr;
		}
		
		/**
		 * 初始化游戏地图
		 * 
		 */		
		public function initMap(pMap:UIComponent, pSmallMap:Canvas):void
		{
        	gameMap = pMap;
        	smallMap = pSmallMap;
        	
        	if (mapSliceList == null)
        		mapSliceList = new MapSliceList();
        	
			//初始化地图容器
			gameMap.width = MapUtil.mapRow * MapUtil.sliceWidth;
			gameMap.height = MapUtil.mapCol * MapUtil.sliceHeight;
			drawMapBG();
			
			gameMap.addEventListener(MouseEvent.MOUSE_DOWN, mapDown);
			gameMap.addEventListener(MouseEvent.MOUSE_MOVE, mapMove);
			gameMap.addEventListener(MouseEvent.MOUSE_UP, mapUp);

			//初始化小地图
			drawSmallMap();
			smallMap.addEventListener(MouseEvent.MOUSE_DOWN, smallMapDown);
			smallMap.addEventListener(MouseEvent.MOUSE_UP, smallMapUp);
			
			createCity();
			
			createCityName();
			
			isInitMap = true;
		}
		
		//===============================================================================
		// 大地图操作
		//===============================================================================
		
		//地图容器
		private static var gameMap:UIComponent = null;
		
		//游戏客户端主界面中心点对应的切片名称
		private var ctSliceX:int = 0;
		private var ctSliceY:int = 0;
		
		//地图切片对象列表类
		private var mapSliceList:MapSliceList = null;
		//需要加载的切片列表
		private var sliceList:Array = [];
		
		//正在加载的切片索引
		private var sliceIndex:int = 0;
		
		//正在加载地图
		private var isLoading:Boolean = false;
		
		//正在拖动地图
		private var isMapMove:Boolean = false;
		
		/**
		 * 设置大地图的默认背景 
		 * 
		 */		
		private function drawMapBG():void
		{
			if (gameMap == null) return;
			
			var BG:Class = AssetsManager.assetsMgr.MAP_BG;
			var bgBitmap:Bitmap = new BG();
			
		    gameMap.graphics.beginBitmapFill(bgBitmap.bitmapData, new Matrix(), true);
			gameMap.graphics.drawRect(0, 0, gameMap.width, gameMap.height);
		    gameMap.graphics.endFill();
		}
		
		/**
		 * 鼠标在大地图上按下 
		 * @param evt
		 * 
		 */		
		private function mapDown(evt:MouseEvent):void
		{
			if (isLoading) return;
			if (evt.target is SWFLoader) return;
			
			var maxWidth:int = GameManager.gameMgr.gameApp.width - gameMap.width;
			var maxHeight:int = GameManager.gameMgr.gameApp.height - gameMap.height;
			
			gameMap.startDrag(false, new Rectangle(0, 0, maxWidth, maxHeight));
		}
		
		/**
		 * 鼠标拖动大地图
		 * @param evt
		 * 
		 */		
		private function mapMove(evt:MouseEvent):void
		{
			if (!evt.buttonDown)
			{
				return;
			}
			
			CursorManager.setCursor(AssetsManager.assetsMgr.CUR_DRAG);
			isMapMove = true;
		}
		
		/**
		 * 鼠标在大地图上松开 
		 * @param evt
		 * 
		 */		
		private function mapUp(evt:MouseEvent):void
		{
			CursorManager.removeAllCursors();
			
			if (!evt.ctrlKey)
			{
				gameMap.stopDrag();
				refreshMap();
				setSmallMapPos();
			}
			
			if (evt.target is SWFLoader) return;
			if (evt.target is MovieClip) return;
			if (evt.target is Canvas) return;
			if (evt.target is Button) return;
			
			if (!isMapMove)
			{
				if (cityMenu != null)
				{
					cityMenu.visible = false;
					cityMenu.includeInLayout = false;
				}
				
				var pt:Point = new Point();
				
			}
			
			isMapMove = false;
			gameMap.setFocus();
		}
		
		/**
		 * 加载地图 
		 * @param posX
		 * @param posY
		 * @param isSet 是否需要重新定位地图容器
		 *              如果刚进入游戏或选择城池时需要定位，当拖动地图时不需要定位
		 * 
		 */		
		private function loadMap(posX:Number, posY:Number, isSet:Boolean = true):void
		{
			if (posX < 0 || posY < 0) return;
			
			var sliceX:int = 0;
			var sliceY:int = 0;
			var point:Point = null;
			var xFix:Number = 0;
			var yFix:Number = 0;
			
			//修正坐标,如果坐标在边界角落，则取相对应的中心点坐标
			var px:int = GameManager.gameMgr.gameApp.width / 2;
			var py:int = GameManager.gameMgr.gameApp.height / 2;
			  
			if (posX * MapUtil.mapGridW < px)
				xFix = px - posX * MapUtil.mapGridW;
			else if (MapUtil.sliceWidth * MapUtil.mapRow - posX * MapUtil.mapGridW < px)
				xFix = (MapUtil.sliceWidth * MapUtil.mapRow - posX * MapUtil.mapGridW) - px;
			else
				xFix = 0;
				
			if (posY * MapUtil.mapGridH < py)
				yFix = py - posY * MapUtil.mapGridH;
			else if (MapUtil.sliceHeight * MapUtil.mapCol - posY * MapUtil.mapGridH < py)
				yFix = (MapUtil.sliceHeight * MapUtil.mapCol - posY * MapUtil.mapGridH) - py;
			else
				yFix = 0;
			
			posX = posX + xFix / MapUtil.mapGridW;
			posY = posY + yFix / MapUtil.mapGridH;
			
			//计算对应的切片名称
			point = getSliceMap(new Point(posX * MapUtil.mapGridW, posY * MapUtil.mapGridH));
			sliceX = point.x;
			sliceY = point.y;
			
			//定位地图容器的像素坐标
			if (isSet)
				setMapPos(sliceX, sliceY, posX, posY);
			
			//根据此切片计算需要加载的切片列表
			var lap:int = 0;
			if (GameManager.gameMgr.gameApp.width > 1024)
				lap = 2;
			else
				lap = 1;		
			sliceList = mapSliceList.getSliceList(sliceX, sliceY, lap);
			
			sliceIndex = 0;
			startLoadMap();
				
			//定位小地图中选择框的像素坐标
			setSmallMapPos();
			
			//移除切片
			removeMapSlice();
			
			//将主窗口中心对应的切片名称暂存起来
	        ctSliceX = sliceX;
	        ctSliceY = sliceY;
		}
		
		/**
		 * 定位大地图的像素坐标 
		 * @param sliceX
		 * @param sliceY
		 * 
		 */		
		private function setMapPos(sliceX:int, sliceY:int, posX:Number, posY:Number):void
		{
			if (sliceX < 0 || sliceY < 0 ) return;
			
		    var centerX:Number = sliceX * MapUtil.sliceWidth / MapUtil.mapGridW + MapUtil.sliceWidth / MapUtil.mapGridW * 0.5;
		    var centerY:Number = sliceY * MapUtil.sliceHeight / MapUtil.mapGridH + MapUtil.sliceHeight / MapUtil.mapGridH * 0.5;
		    var offSetX:Number = posX - centerX;
		    var offSetY:Number = posY - centerY;
			    
		    gameMap.x = -(sliceX * MapUtil.sliceWidth) + MapUtil.mapGridW / 2 + (GameManager.gameMgr.gameApp.width - MapUtil.sliceWidth) / 2;
		    gameMap.y = -(MapUtil.mapCol - sliceY - 1) * MapUtil.sliceHeight - MapUtil.mapGridH / 2 + (GameManager.gameMgr.gameApp.height - MapUtil.sliceHeight) / 2;
		    
		    gameMap.x = gameMap.x - offSetX * MapUtil.mapGridW;
		    gameMap.y = gameMap.y + offSetY * MapUtil.mapGridH;
		    
		    if (gameMap.x > 0) gameMap.x = 0;
		    if (gameMap.x < -(MapUtil.mapRow * MapUtil.sliceWidth - GameManager.gameMgr.gameApp.width))
		        gameMap.x = -(MapUtil.mapRow * MapUtil.sliceWidth - GameManager.gameMgr.gameApp.width);
		    if (gameMap.y > 0) gameMap.y = 0;
		}
		
		/**
		 * 开始加载地图切片 
		 * 
		 */		
		private function startLoadMap():void
		{
			//加载地图切片
			if (sliceList == null || sliceList.length < 1) return;
			
			if (sliceIndex > sliceList.length - 1)
			{
				isLoading = false;
				sliceIndex = 0;
				sliceList.length = 0;
			}
			else
			{
				isLoading = true;
				addMapSlice();
			}
		}
		
		/**
		 * 添加切片到大地图 
		 * 
		 */		
		private function addMapSlice():void
		{
			var mapX:String = sliceList[sliceIndex].mapX;
			var mapY:String = sliceList[sliceIndex].mapY;
			
			var mapSlice:MapSlice = new MapSlice();
			
			mapSlice.mapX = mapX;
			mapSlice.mapY = mapY;
			mapSlice.mapURL = GameManager.gameMgr.resURL + "map1/" + mapX + mapY + MapUtil.mapSuffix;
			mapSlice.x = int(sliceList[sliceIndex].mapX) * MapUtil.sliceWidth;
			mapSlice.y = (MapUtil.mapCol - int(sliceList[sliceIndex].mapY) - 1) * MapUtil.sliceHeight;
			mapSlice.addEventListener(Event.COMPLETE, onLoadComp);
			mapSlice.startLoad();
			
			gameMap.addChild(mapSlice);
			swapChildIndex();
		}
		
		/**
		 * 加载切片完成 
		 * @param evt
		 * 
		 */		
		private function onLoadComp(evt:Event):void
		{
			sliceIndex ++;
			startLoadMap();
		}
		
		/**
		 * 调整地图中对象的深度索引
		 * 
		 */		
		private function swapChildIndex():void
		{
			var i:int = 0;
			var index:int = 0;
			var mapSlice:MapSlice = null;
			var mapCity:MapCity = null;
			
			//设置地图切片的索引
			for(i = 0; i < gameMap.numChildren;i++)
			{
				if (gameMap.getChildAt(i) is MapSlice)
				{
					mapSlice = gameMap.getChildAt(i) as MapSlice;
					gameMap.setChildIndex(mapSlice, index);
					index++;
				}
			}
			
			//设置地图城池的索引
			for(i = 0; i < gameMap.numChildren;i++)
			{
				if (gameMap.getChildAt(i) is MapCity)
				{
					mapCity = gameMap.getChildAt(i) as MapCity;
					gameMap.setChildIndex(mapCity, index);
					index++;
				}
			}
			
		}
		
		/**
		 * 刷新当前地图，判断当前是否需要加载新的地图切片 
		 * 
		 */		
		private function refreshMap():void
		{
			//获取中心点的游戏坐标
			var point:Point = getCenterPoint();
			
			point.x = point.x / MapUtil.mapGridW;
			point.y = point.y / MapUtil.mapGridH;
			
			point = MapUtil.transCoor(point.x, point.y);
			
			//获取中心点对应的切片
			var pointTemp:Point = new Point();
			pointTemp.x = point.x * MapUtil.mapGridW;
			pointTemp.y = point.y * MapUtil.mapGridH;
			
			var ctPoint:Point = getSliceMap(pointTemp); 
			
			//如果中心点对应的切片与上次对应的切片不一样时，开始加载新的图片
			if (ctPoint.x != ctSliceX || ctPoint.y != ctSliceY)
			{
		    	sliceIndex = 0;
		    	sliceList.length = 0;
		    	loadMap(point.x, point.y, false);
		    }
		        
		}
		
		/**
		 * 移除地图切片 
		 * 
		 */		
		private function removeMapSlice():void
		{
			var removeSliceList:Array = mapSliceList.mapRemoveSliceList;
			if (removeSliceList == null) return;
			
			var i:int = 0;
			for(i = 0; i < removeSliceList.length; i++)
			{
				var mapSlice:MapSlice = getMapSlice(removeSliceList[i].mapX, removeSliceList[i].mapY);
				
				if (mapSlice != null)
				{
					try
					{
						mapSlice.clear();
						gameMap.removeChild(mapSlice);
						mapSlice = null;
					}
					catch(e:Error)
					{
						
					}
				}
			}
		}
		
		/**
		 * 判断地图容器是否存在某个切片对象, 返回null表示不存在 
		 * @param gameMap
		 * @param mapX
		 * @param mapY
		 * @return 
		 * 
		 */		
		private function getMapSlice(mapX:String, mapY:String):MapSlice
		{
			if (gameMap == null) return null;
			if (mapX == "" || mapY == "") return null;
			
		    var mapSlice:MapSlice = null;
		
		    for(var i:int = 0; i < gameMap.numChildren;i++)
		    {
		        if (gameMap.getChildAt(i) is MapSlice)
				{
				    mapSlice = gameMap.getChildAt(i) as MapSlice;
			
				    if (mapSlice.mapX == mapX && mapSlice.mapY == mapY)
				    	return mapSlice;
				}
		    }
		
		    return null;
		}
		
		/**
		 * 根据地图坐标计算对应的地图切片 
		 * @param point
		 * @return 
		 * 
		 */		
		private function getSliceMap(point:Point):Point
		{
			var ret:Point = new Point();
			
			ret.x = int(point.x / MapUtil.sliceWidth);
			ret.y = int(point.y / MapUtil.sliceHeight);
			
			return ret;
		}
			
		/**
		 * 获取主界面的中心点在地图容器中的像素坐标 
		 * @return 
		 * 
		 */		
		private function getCenterPoint():Point
		{
		   var ret:Point = new Point();
		
		   ret.x = -gameMap.x + GameManager.gameMgr.gameApp.width / 2;
		   ret.y = -gameMap.y + GameManager.gameMgr.gameApp.height / 2;
			
		   return ret;
		}
		
		/**
		 * 将坐标转换为寻路所需坐标 
		 * @param point
		 * 
		 */		
		private function transPoint(point:Point):void
		{
			point.x = Math.floor(point.x / MapUtil.mapGridW);
			point.y = Math.floor(point.y / MapUtil.mapGridH);
		}
		
		/**
		 * 将寻路后得到的路点转换为路径序列 
		 * @param pathList
		 * @return 
		 * 
		 */		
		private function transPathToSeq(pathList:Array):Array
		{
			var ret:Array = new Array();
			var point:Point = new Point();
			var i:int = 0;
			
			for(i = 0; i < pathList.length;i++)
			{
				point.x = pathList[i][0];
				point.y = pathList[i][1];
				point = MapUtil.transCoor(point.x, point.y);
				
				ret[i] = new Array();
				ret[i][0] = point.x;
				ret[i][1] = point.y;
			}
			
			return ret;
		}
		
		//===============================================================================
		// 小地图操作
		//===============================================================================
		
		private static var smallMap:Canvas = null;
		
		private var mapSel:MapSel = null;
		
		private var cityPointList:CityPointList = new CityPointList();
		
		/**
		 * 定位小地图的中选择框的坐标 
		 * 
		 */		
		private function setSmallMapPos():void
		{
		    var point:Point = getCenterPoint();
		    
		    mapSel.x = int(point.x / 20 - mapSel.width / 2) + 4;
		    mapSel.y = int(point.y / 20 - mapSel.height / 2) + 4;
		}
		
		/**
		 * 绘制小地图并在小地图上描点 
		 * 
		 */		
		public function drawSmallMap():void
		{
			var rate:int = 3;
			var mapWidth:int = 258;
			
			if (smallMap == null) return;
			
			smallMap.removeAllChildren();
			
			//定义小地图选择框
			mapSel = new MapSel(GameManager.gameMgr.gameApp.width, GameManager.gameMgr.gameApp.height, mapWidth);
			mapSel.x = 0;
			mapSel.y = 0;
			smallMap.addChild(mapSel);
			
			var i:int = 0;
			var len:int = 0;
			var cityPoint:CityPoint = null;
			var r:int = 0;
			var pColor:int = 0;
			var gameCity:City = null;
			var sphereID:int = 0;
			var gameSphere:Sphere = null;
			
			len = GameManager.gameMgr.cityList.length;
			sphereID = GameManager.gameMgr.wubao.sphereID;
			cityPointList.removeAll();
			
			var sphereList:SphereList = GameManager.gameMgr.sphereList;
			sphereList.randomColor();
			
			for (i = 0; i < len; i++)
			{
				gameCity = GameManager.gameMgr.cityList.getObjByIndex(i) as City;
				r = gameCity.level + 1;
				
				if (gameCity.sphereID == 0)
					pColor = PubUnit.WHITE;
				else
				{
					sphereID = gameCity.sphereID;
					gameSphere = sphereList.getObjByID(sphereID) as Sphere;
					if (gameSphere != null)
						pColor = gameSphere.mapColor;
				}
				
				cityPoint = new CityPoint();
				cityPoint.uniqID = i + 1;
				cityPoint.gameCity = gameCity;
				cityPoint.pWidth = r;
				cityPoint.pHeight = r;
				
				cityPoint.x = int(gameCity.mapX / 20 - r / 2) + 4;
				cityPoint.y = int(gameCity.mapY / 20 - r / 2) + 4;
				cityPoint.pColor = pColor;
				cityPoint.draw();
				cityPoint.addEventListener(MouseEvent.CLICK, pointClick);
				
				smallMap.addChild(cityPoint);
				cityPointList.add(cityPoint);
				cityPoint.setToolTip();
			}
			
			setSmallMapPos();
		}
		
		private function pointClick(evt:MouseEvent):void
		{
			var cityPoint:CityPoint = evt.target as CityPoint;
			
			posMap(cityPoint.gameCity.mapX, cityPoint.gameCity.mapY);
		}
		
		private function pointOver(evt:MouseEvent):void
		{
			var cityPoint:CityPoint = evt.target as CityPoint;
			cityPoint.toolTip = FormatText.packegText("城池 ");//cityPoint.getToolTip();
		}
		
		private var isSmallMapMove:Boolean = false;
		
		private function smallMapDown(evt:MouseEvent):void
		{
			if (evt.target is Canvas)
			{
				var cv1:Canvas = evt.target as Canvas;
				cv1.startDrag();
			}
			
			isSmallMapMove = false;
			smallMap.addEventListener(MouseEvent.MOUSE_MOVE, smallMapMove);
		}
		
		private function smallMapUp(evt:MouseEvent):void
		{
			smallMap.removeEventListener(MouseEvent.MOUSE_MOVE, smallMapMove);
			
			if (evt.target is Canvas)
			{
				var cv1:Canvas = evt.target as Canvas;
				cv1.stopDrag();
			}
			
			if (evt.target is CityPoint) return;
			if (isSmallMapMove) return;
			
			isSmallMapMove = false;
			
			var mapX:Number = evt.localX * 20 / MapUtil.mapGridW;
			var mapY:Number = (MapUtil.mapCol * MapUtil.sliceHeight - evt.localY * 20) / MapUtil.mapGridH;
			loadMap(mapX, mapY);
		}
		
		private function smallMapMove(evt:MouseEvent):void
		{
			if (evt.buttonDown)
				isSmallMapMove = true;
		}
			
		/**
		 * 用黄色显示小地图中的某个城池  
		 * @param cityID
		 * 
		 */		
		public function drawCityPoint(cityID:int):void
		{
			resetAllCityPoint();
			
			var i:int = 0;
			var len:int = 0;
			var cityPoint:CityPoint = null;
			
			len = cityPointList.length;
			
			for (i = 0; i < len; i++)
			{
				cityPoint = cityPointList.getObjByIndex(i) as CityPoint;
				if (cityPoint.gameCity.uniqID == cityID)
				{
					cityPoint.pColor = PubUnit.YELLOW;
					cityPoint.draw();
				}
			}
		}
		
		/**
		 * 用黄色显示小地图中的某个势力的所有城池 
		 * @param sphereID
		 * 
		 */		
		public function drawSpherePoint(sphereID:int):void
		{
			resetAllCityPoint();
			
			var i:int = 0;
			var len:int = 0;
			var cityPoint:CityPoint = null;
			
			len = cityPointList.length;
			
			for (i = 0; i < len; i++)
			{
				cityPoint = cityPointList.getObjByIndex(i) as CityPoint;
				if (cityPoint.gameCity.sphereID == sphereID)
				{
					cityPoint.pColor = PubUnit.YELLOW;
					cityPoint.draw();
				}
			}
		}
		
		/**
		 * 恢复小地图中所有势力的颜色 
		 * 
		 */		
		public function resetAllCityPoint():void
		{
			var i:int = 0;
			var len:int = 0;
			var cityPoint:CityPoint = null;
			var selfID:int = 0;
			var targetID:int = 0;
			
			selfID = GameManager.gameMgr.wubao.sphereID;
			len = cityPointList.length;
			
			for (i = 0; i < len; i++)
			{
				cityPoint = cityPointList.getObjByIndex(i) as CityPoint;
				
				if (GameManager.gameMgr.wubao.cityID == cityPoint.gameCity.uniqID)
				{
					cityPoint.pColor = PubUnit.GREEN;
					cityPoint.draw();
					continue;
				}
				
				if (cityPoint.gameCity.sphereID == 0)
				{
					cityPoint.pColor = PubUnit.WHITE;
					cityPoint.draw();
					continue;
				}
				else
				{
					targetID = cityPoint.gameCity.sphereID;
					
					if (cityPoint.gameCity.sphereID == selfID)
					{
						cityPoint.pColor = PubUnit.CYAN;
						cityPoint.draw();
						continue;
					}
					
					if (GameManager.gameMgr.dipList.isAlli(selfID, targetID))
					{
						cityPoint.pColor = PubUnit.BLUE;
						cityPoint.draw();
						continue;
					}
					
					if (GameManager.gameMgr.dipList.isEne(selfID, targetID))
					{
						cityPoint.pColor = PubUnit.RED;
						cityPoint.draw();
						continue;
					}
				}
				
				cityPoint.pColor = PubUnit.WHITE;
				cityPoint.draw();
			}
		}
		
		//===============================================================================
		// 城池
		//===============================================================================
		
		//地图城池列表类，用来管理地图上的城池对象
		private var mapCityList:MapCityList = new MapCityList();
		
		//点击城池弹出的菜单
		private var cityMenu:CityMenu = null;
		
		//当前选中的城池
		private var selCity:MapCity = null;
		
		//城池名称标签列表
		private var cityNameList:Array = [];
		
		private var mapFlagList:Array = [];
		
		private function createCity():void
		{
			var i:int = 0;
			var len:int = 0;
			var gameCity:City = null;
			var mapCity:MapCity = null;
			var point:Point = null;
			
			len = GameManager.gameMgr.cityList.length;
			
			for (i = 0; i < len; i++)
			{
				gameCity = GameManager.gameMgr.cityList.getObjByIndex(i) as City;
				
				mapCity = new MapCity();
				mapCity.uniqID = gameCity.uniqID;
				mapCity.gameCity = gameCity;
					
				mapCity.showCity();
				mapCity.x = gameCity.mapX - mapCity.width / 2;
				mapCity.y = gameCity.mapY - mapCity.height / 2;
				gameMap.addChild(mapCity);
				mapCityList.add(mapCity);
				mapCity.addEventListener(MouseEvent.CLICK, cityClick);
			}
			
		}
		
		/**
		 * 鼠标点击城池 
		 * @param evt
		 * 
		 */		
		private function cityClick(evt:MouseEvent):void
		{
			if (isMapMove) return;
			
			if (evt.target is MapCity) 
			{
				var mapCity:MapCity = evt.target as MapCity;
				var pt:Point = new Point();
				
				selCity = mapCity;
				if (cityMenu == null)
				{
					cityMenu = new CityMenu();
					gameMap.addChild(cityMenu);
				}
				
				cityMenu.cityID = mapCity.uniqID;
				cityMenu.setButton();
				cityMenu.x = mapCity.x + mapCity.width;
				cityMenu.y = mapCity.y - 20;
				cityMenu.visible = true;
				cityMenu.includeInLayout = true;
				
			}
			
			evt.stopPropagation();
		}
		
		/**
		 * 在地图上创建城池名称标签以及旗帜
		 * 
		 */		
		private function createCityName():void
		{
			var i:int = 0;
			var len:int = 0;
			var mapCity:MapCity = null;
			var cityName:Label = null;
			var mapFlag:MapFlag = null;
			
			len = mapCityList.length;
			
			for (i = 0; i < len; i++)
			{
				mapCity = mapCityList.getObjByIndex(i) as MapCity;
				
				cityName = new Label();
				cityName.text = mapCity.gameCity.cityName;
				cityName.width = mapCity.width;
				cityName.height = 16;
				cityName.x = mapCity.x;
				cityName.y = mapCity.y - cityName.height;
				cityName.data = mapCity.uniqID;
				cityName.setStyle("fontSize", 12);
				cityName.setStyle("fontWeight", "bold");
				cityName.setStyle("fontFamily", "新宋体");
				cityName.setStyle("color", PubUnit.WHITE);
				cityName.setStyle("textAlign", "center");
				gameMap.addChild(cityName);
				cityNameList.push(cityName);
				
				mapFlag = new MapFlag();
				mapFlag.gameCity = mapCity.gameCity;
				if (mapCity.gameCity.sphereName == "")
				{
					mapFlag.visible = false;
					mapFlag.includeInLayout = false;
				}
				
				if (mapCity.gameCity.level == 2)
				{
					mapFlag.x = mapCity.x - 13;
					mapFlag.y = mapCity.y - 22;
				}
				else if (mapCity.gameCity.level == 3)
				{
					mapFlag.x = mapCity.x - 8;
					mapFlag.y = mapCity.y - 13;
				}
				else if (mapCity.gameCity.level == 4)
				{
					mapFlag.x = mapCity.x - 3;
					mapFlag.y = mapCity.y - 8;
				}
				
				gameMap.addChild(mapFlag);
				mapFlagList.push(mapFlag);
			}
		}
		
		//===============================================================================
		// 公共函数
		//===============================================================================
		
		/**
		 * 定位坐标
		 * @param mapX
		 * @param mapY
		 * 
		 */		
		public function posMap(mapX:Number, mapY:Number):void
		{
			var mapX:Number = mapX / MapUtil.mapGridW;
			var mapY:Number = (MapUtil.mapCol * MapUtil.sliceHeight - mapY) / MapUtil.mapGridH;
			
			loadMap(mapX, mapY);
		}
		
		/**
		 * 定位坞堡所在的城 
		 * 
		 */		
		public function posSelfCity():void
		{
			var cityID:int = GameManager.gameMgr.wubao.cityID;
			var gameCity:City = GameManager.gameMgr.cityList.getObjByID(cityID) as City;
			if (gameCity != null)
			{
				posMap(gameCity.mapX, gameCity.mapY);
			}
		}
		
		/**
		 * 设置城池状态 
		 * @param gameCity
		 * 
		 */		
		public function setCityState(gameCity:City):void
		{
			var mapCity:MapCity = mapCityList.getObjByID(gameCity.uniqID) as MapCity;
			if (mapCity != null)
			{
				mapCity.gameCity = gameCity;
				mapCity.refresh();
			}
			
			var i:int = 0;
			var mapFlag:MapFlag = null;
			
			for (i = 0; i < mapFlagList.length; i++)
			{
				mapFlag = mapFlagList[i];
				if (mapFlag != null && mapFlag.gameCity != null && mapFlag.gameCity.uniqID == gameCity.uniqID)
				{
					mapFlag.visible = true;
					mapFlag.includeInLayout = true;
					mapFlag.gameCity = gameCity;
				}
			}
			
			drawSmallMap();
		}
		

		
		/**
		 * 隐藏城池操作菜单 
		 * 
		 */		
		public function hideCityMenu():void
		{
			if (cityMenu != null)
			{
				cityMenu.visible = false;
				cityMenu.includeInLayout = false;
			}
		}
		
		//===============================================================================
		// 属性
		//===============================================================================
		
		public function get isInitMap():Boolean
		{
			return _isInitMap;
		}
		
		public function set isInitMap(param:Boolean):void
		{
			_isInitMap = param;
		}
		
	}
}