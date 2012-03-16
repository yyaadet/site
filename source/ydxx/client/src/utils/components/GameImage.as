package utils.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	import utils.PubUnit;
	
	/**
	 * 自定义Image类
	 * 
	 */  
	public class GameImage extends Canvas
	{
		public static const INIT_FINISH:String = "init_finish"; 
		
		//图片名称,如果不指定，则不会存图片到本地
		private var _imageName:String = "";
		
		//图片地址
		private var _imageURL:Object;
		
		//鼠标移到图片上，是否发光显示
		private var _canSel:Boolean = false;
		
		private var _progressHandle:Function = null;
		
		//图片加载器
		private var loader:Loader = null;
		
		private var uiLoad:UIComponent = null;
		
		//处理可点击区域
		private var bit:BitmapData = null;
		private var ht:Sprite = new Sprite();
		
		public function GameImage()
		{
			super();
			
			if (loader == null)
				loader = new Loader();
			
			var ui:UIComponent = new UIComponent();
			ui.addChild(ht);
			addChild(ui);
			
			hitArea = ht;
			ht.visible = false;
			ht.mouseEnabled = false;
			mouseChildren = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function startLoad():void
		{
			if (imageURL is String)
			{
				if (imageURL == "")
				{
					remove();
					return;
				}
				
				//判断本地是否存储了地图图片
				var bytes:ByteArray = getImage();
				
				//如果没有存储，从web服务器获取图片
				if (bytes == null)
					loadImage();
				//如果已存储了，从本地获取图片
				else
				{
					if (loader == null)
						loader = new Loader();
						
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadLocalComp);
		            if (_progressHandle != null)
		            {
						loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _progressHandle);
		            }
		            
					loader.loadBytes(bytes);
				}
			}
			else if (imageURL is Bitmap)
			{
				if (imageURL == null) return;
				remove();
				
				this.graphics.beginBitmapFill(imageURL.bitmapData, new Matrix(), false);
				this.graphics.drawRect(0, 0, this.width, this.height);
				this.graphics.endFill();
				
				update();
			}
			else if (imageURL is Class)
			{
				remove();
				
				this.setStyle("backgroundImage", imageURL);
			}
		}
		
		/**
		 * 从web获取图片 
		 * 
		 */		
		private function loadImage():void
		{
			if (loader == null)
				loader = new Loader();
				
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImageComplete);
            if (_progressHandle != null)
            {
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _progressHandle);
            }
			loader.load(new URLRequest(imageURL as String));
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
			uiLoad = new UIComponent();
			uiLoad.addChild(loader);
			this.addChild(uiLoad);
			
			dispatchFinish();
		    saveImage();
		    update();
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
			uiLoad = new UIComponent();
			uiLoad.addChild(loader);
			this.addChild(uiLoad);
			
			dispatchFinish();
			update();
		}
		
		private function dispatchFinish():void
		{
			this.dispatchEvent(new Event(INIT_FINISH));
		}
		
		/**
		 * 将图片存储在本地 
		 * 
		 */		
		private function saveImage():void
		{
			if (imageName == "") return;
			
			var so:SharedObject = SharedObject.getLocal(imageName);
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
		 * @return 
		 * 
		 */		
		private function getImage():ByteArray
		{
			if (imageName == "") return null;
			
			var so:SharedObject = SharedObject.getLocal(imageName);
			if (so == null || so.size < 1) return null;
			
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
		
		private function update():void
		{
			if (!canSel) return;
			
			bit = new BitmapData(this.width, this.height, true, 0x000000);
			bit.draw(this);
			
			ht.graphics.clear();
			ht.graphics.beginFill(0);
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < bit.width; i++)
			{
				for (j = 0; j < bit.height; j++)
				{
					if (bit.getPixel32(i, j))
						ht.graphics.drawRect(i, j, 1, 1);
				}
			}
			ht.graphics.endFill();
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			if (!canSel) return;
			
			PubUnit.addColor(this);
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			if (!canSel) return;
			
			PubUnit.clearColor(this);
		}
		
		private function remove():void
		{
			if (uiLoad != null && loader != null)
			{
				loader.unload();
				uiLoad.removeChild(loader);
				loader = null;
				this.removeChild(uiLoad);
				uiLoad = null;
			}
		}
		
		public function removeSel():void
		{
			PubUnit.clearColor(this);
		}
		
		public function clear():void
		{
			remove();
		}
		
		//====================================================================================
		// 属性
		//====================================================================================
		
		public function get imageName():String
		{
			return _imageName; 
		}
		
		public function set imageName(param:String):void
		{
			_imageName = param;
		}
		
		public function get imageURL():Object
		{
			return _imageURL; 
		}
		
		public function set imageURL(param:Object):void
		{
			_imageURL = param;
			
			startLoad();
		}
		
		public function get canSel():Boolean
		{
			return _canSel; 
		}
		
		public function set canSel(param:Boolean):void
		{
			_canSel = param;
		}
		
		public function get progressHandle():Function
		{
			return _progressHandle; 
		}
		
		public function set progressHandle(param:Function):void
		{
			_progressHandle = param;
		}
		
		public function get imageUI():UIComponent
		{
			return uiLoad;
		}
	}
}
