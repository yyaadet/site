package map.model
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import map.MapUtil;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;

	/**
	 * 地图切片类 
	 * @author StarX
	 * 
	 */	
	public class MapSlice extends UIComponent
	{
		//地图切片名称的X
		private var _mapX:String = "";
		
		//地图切片名称的Y
		private var _mapY:String = "";
		
		//地图切片地址
		private var _mapURL:String = "";
		
		//地图加载器
		private var loader:Loader = null;
		
		//加载失败后显示重新加载标签
		private var reLoad:Label = null;
		
		public function MapSlice()
		{
			super();
			
			this.width = MapUtil.sliceWidth;
			this.height = MapUtil.sliceHeight;
			
			if (loader == null)
				loader = new Loader();
		}
		
		//============================================================
		//公共函数
		//============================================================
		
		/**
		 * 开始加载地图图片 
		 * 
		 */		
		public function startLoad():void
		{
			//判断本地是否存储了地图图片
			var bytes:ByteArray = getImage();
			
			//如果没有存储，从web服务器获取图片
			if (bytes == null)
			{
				if (StringUtil.trim(_mapURL) != "")
					loadImage(_mapURL);
			}
			//如果已存储了，从本地获取图片
			else
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadLocalComp);
				loader.loadBytes(bytes);
				
				dispatchSuccess();
			}
			
			
		}
		
		/**
		 * 清除，释放内存
		 * 
		 */		
		public function clear():void
		{
			if (loader != null)
			{
				removeAllEventListener();
				loader.unload();
				this.removeChild(loader);
				loader = null;
			}
			
			if (reLoad != null)
			{
				reLoad.removeEventListener(MouseEvent.CLICK, reLoadImage);
				reLoad.removeEventListener(MouseEvent.MOUSE_OVER, reLoadOver);
				reLoad.removeEventListener(MouseEvent.MOUSE_OUT, reLoadOut);
				
				this.removeChild(reLoad);
				reLoad = null;
			}
		}
		
		//============================================================
		//私有函数
		//============================================================
		
		/**
		 * 根据链接加载图片 
		 * @param url
		 * 
		 */		
		private function loadImage(url:String):void
		{
			if (StringUtil.trim(_mapURL) == "") return;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImageComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadImageError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadImagePros);
			
			loader.load(new URLRequest(url));
		}
		
		/**
		 * 移除所有监听事件 
		 * 
		 */		
		private function removeAllEventListener():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadImageComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadImageError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadImagePros);
		}
		
		/**
		 * 加载Web图片成功 
		 * @param evt
		 * 
		 */		
		private function loadImageComplete(evt:Event):void
		{
			if (loader == null) return;
			
			loader.x = 0;
			loader.y = 0;
			loader.width = this.width;
			loader.height = this.height;
			this.addChild(loader);
			addMapNameLabel();
			
			if (reLoad != null)
				reLoad.visible = false;
				
			//将图片存储本地
		    saveImage();
			removeAllEventListener();
			
			dispatchSuccess();
		}
		
		/**
		 * 加载本地图片成功 
		 * @param evt
		 * 
		 */		
		private function loadLocalComp(evt:Event):void
		{
			if (loader == null) return;
			
			loader.x = 0;
			loader.y = 0;
			loader.width = this.width;
			loader.height = this.height;
			this.addChild(loader);
			addMapNameLabel();
			
			if (reLoad != null)
				reLoad.visible = false;
		}
		
		/**
		 * 加载图片失败 
		 * @param evt
		 * 
		 */		
		private function loadImageError(evt:IOErrorEvent):void
		{
			if (reLoad == null)
			{
				reLoad = new Label();
				reLoad.text = "加载地图失败，请刷新重试";
				reLoad.useHandCursor = true;
				reLoad.mouseChildren = false;
				reLoad.buttonMode = true;
				reLoad.x = 0;
				reLoad.y = (this.height - reLoad.height) / 2;
				reLoad.setStyle("textAlign", "center");
				reLoad.setStyle("color", 0xFFFFFF);
				reLoad.setStyle("fontSize", 12);
				reLoad.width = 150;
				reLoad.height = 20;
				reLoad.addEventListener(MouseEvent.CLICK, reLoadImage);
				reLoad.addEventListener(MouseEvent.MOUSE_OVER, reLoadOver);
				reLoad.addEventListener(MouseEvent.MOUSE_OUT, reLoadOut);
				this.addChild(reLoad);
			}
			
			removeAllEventListener();
		}
		
		/**
		 * 正在加载图片 
		 * @param evt
		 * 
		 */		
		private function loadImagePros(evt:ProgressEvent):void
		{
			
		}
		
		/**
		 * 加载失败后，点击重新加载标签 
		 * @param evt
		 * 
		 */		
		private function reLoadImage(evt:MouseEvent):void
		{
			loadImage(_mapURL);
		}
		
		/**
		 * 鼠标移至重新加载标签 
		 * @param evt
		 * 
		 */		
		private function reLoadOver(evt:MouseEvent):void
		{
			reLoad.setStyle("color", 0xFF0000);
		}
		
		/**
		 * 鼠标移出重新加载标签 
		 * @param evt
		 * 
		 */		
		private function reLoadOut(evt:MouseEvent):void
		{
			reLoad.setStyle("color", 0xFFFFFF);
		}
		
		/**
		 * 将图片存储在本地 
		 * 
		 */		
		private function saveImage():void
		{
			var so:SharedObject = SharedObject.getLocal(mapX + mapY);
			if (so == null) return;
			
			so.data.pic = loader.contentLoaderInfo.bytes;
			try
			{
				so.flush();
				so.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			}
			catch(e:Error)
			{
				trace(e.toString());
			}
			
		} 
		
		private function netStatus(evt:NetStatusEvent):void
		{
			
		}
		
		/**
		 * 从本地获取图片 
		 * 
		 */		
		private function getImage():ByteArray
		{
			var so:SharedObject = SharedObject.getLocal(mapX + mapY);
			if (so == null) return null;
			
			var bytes:ByteArray = null;
			try
			{
				bytes = so.data.pic;
			}
			catch(e:Error)
			{
				
			}
			
			return bytes;
		}
		
		/**
		 * 在地图上添加地图名称标签(测试用)
		 * 
		 */		
		private function addMapNameLabel():void
		{
			return;
			
			var label:Label = new Label();
			
			label.text = mapX + mapY;
			label.width = 100;
			label.height = 20;
			label.x = 0;
			label.y = 0;
			label.setStyle("color", 0xFFFFFF);
			
			this.addChild(label);
		}
		
		private function dispatchSuccess():void
		{
			var evt:Event = new Event(Event.COMPLETE);
			this.dispatchEvent(evt);
		}
		
		//==============================================================
		//属性
		//==============================================================
		
		public function get mapX():String
		{
			return _mapX;
		}
		
		public function set mapX(param:String):void
		{
			_mapX = param;
		}
		
		public function get mapY():String
		{
			return _mapY;
		}
		
		public function set mapY(param:String):void
		{
			_mapY = param;
		}
		
		public function get mapURL():String
		{
			return _mapURL;
		}
		
		public function set mapURL(param:String):void
		{
			_mapURL = param;
		}
		
	}
}