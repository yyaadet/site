package utils.components 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	/**
	 * swf加载类
	 * http://livedocs.adobe.com/flex/3/html/help.html?content=Working_with_MovieClips_7.html
	 * 
	 * dispatch Event.COMPLETE when swf load complete.
	 * dispatch HTTPStatusEvent.HTTP_STATUS when network is error.
	 * dispatch IOErrorEvent.IO_ERROR when load swf error.
	 * 
	 */	 
	public class GameSwfLoader extends UIComponent
	{
		private var loader:Loader;
		
		private var loader1:Loader;
		
		private var visibleAfterLoaded:Boolean;
		
		private var progressHandle:Function;
		
		private var loadSwfComplete:Boolean = false;
		
		public function GameSwfLoader(progressHandle:Function = null, visibleAfterLoaded:Boolean = true)
		{
			super();
			init(progressHandle, visibleAfterLoaded);
		}
		
		protected function init(progressHandle:Function = null, visibleAfterLoaded:Boolean = true):void
		{
			this.visibleAfterLoaded = visibleAfterLoaded;
			this.progressHandle = progressHandle;
			unLoad();
		}
		
		/**
		 * 加载 
		 * @param externalSwfUrl
		 * @param progressHandle
		 * @param visibleAfterLoaded
		 * 
		 */		
		public function loadSwf(externalSwfUrl:String, progressHandle:Function = null, visibleAfterLoaded:Boolean = true):void
		{
			init(progressHandle, visibleAfterLoaded);
			
			var request:URLRequest = new URLRequest(externalSwfUrl);
			loader = new Loader();
			addListeners(loader.contentLoaderInfo);
			loader.load(request);
			
			if (visibleAfterLoaded)
			{
				loader1 = new Loader();
				addChild(loader1);
			}
		}
		
		private function addListeners(dispatcher:IEventDispatcher):void
		{
           	dispatcher.addEventListener(Event.COMPLETE, completeHandler);
           	dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
           	dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            
            if (progressHandle != null)
            {
				dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandle);
            }
		}

		/**
		 *	load external swf successful.
		 */
		private function completeHandler(event:Event):void
		{
			var loaderinfo:LoaderInfo = event.target as LoaderInfo;
			  
		    // 第二个Loader用于加载第一个Loader加载进来的bytes  
		    loader1.contentLoaderInfo.addEventListener(Event.COMPLETE, loader1Complete);  
		    loader1.loadBytes(loaderinfo.bytes);  
		}
		
		private function loader1Complete(event:Event):void 
		{  
			this.loadSwfComplete = true;
			this.width = loader1.content.width;
			this.height = loader1.content.height;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function httpStatusHandler(event:Event):void
		{
			dispatchEvent(new Event(HTTPStatusEvent.HTTP_STATUS));
		}
		
		private function ioErrorHandler(event:Event):void
		{
			dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}
		
		public function get content():DisplayObject
		{
			var ret:DisplayObject = null;
			
			if (loadSwfComplete)
			{
				return loader1.content;
			}
			
			return null;
		} 
		
		public function get movieClip():MovieClip
		{
			if (this.content)
			{
				return this.content as MovieClip;
			}
			
			return null;
		}
		
		public function get swfLoader():Loader
		{
			return loader1;
		}
		
		public function unLoad():void
		{
			if (loadSwfComplete)
			{
				try
				{
					loader.unload();
					loader1.unload();
					if (visibleAfterLoaded)
					{
						removeChild(loader1);
					}
					
					loader = null;
					loader1 = null;
					this.parent.removeChild(this);
				}
				catch (e:Error)
				{
					
				}
				
				loadSwfComplete = false;
			}
		}

	}
}