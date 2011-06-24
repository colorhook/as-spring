package com.colorhook.spring.context{
	
	
	/**
	 * @author colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * ClassLoader used to load a class from a SWF file in run-time.
	 * 
	 * @example
	 *
	 * <pre>
	 *
	 * var classLoader:ClassLoader=new ClassLoader();
	 * var myClass:Class;
	 * classLoader.addEventListener("complete",onClassLoaderComplete);
	 * classLoader.load("lib.swf");
	 * function onClassLoaderComplete(e:Event):void{
	 * 		myClss=classLoader.getClass("myClassDef");
	 * }
	 *
	 * </pre>
	 */
	 
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	 
	 /**
	  * this event dispatched when the SWF flie loaded.
	  */
	[Event(name="complete",type="flash.events.Event")]
	
	
	 /**
	  * this event dispatched when the SWF flie has initialized.
	  */
	[Event(name="init",type="flash.events.Event")]
	
	
	/**
	 * this event dispatched if IO error while loading.
	 */
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	
	
	public class ClassLoader extends EventDispatcher{
		
		private var _isSameDomain:Boolean;
		private var _loader:Loader;
	
		/**
		 * @constructor
		 * 构造器
		 */
		public function ClassLoader(){
			_loader=new Loader;
		}
		
		/**
		 * 通过source来加载一个swf, source可以是swf的路径，也可以是一个URLRequest.
		 * url可以是
		 * @param source the URL or URLRequest of the swf file to be loaded.
		 * @param isSameDomain if the swf file loaded in the current application domain.
		 */
		public function load(source:*,isSameDomain:Boolean=true):void{
			_isSameDomain=isSameDomain
			
			if(!_loader.contentLoaderInfo.hasEventListener("complete")){
				_loader.contentLoaderInfo.addEventListener("complete",onLoaderComplete,false,0,true);
				_loader.contentLoaderInfo.addEventListener("init",onLoaderInit,false,0,true);
				_loader.contentLoaderInfo.addEventListener("ioError",onLoaderIOError,false,0,true);
			}
			
			var context:LoaderContext = new LoaderContext();
			if (_isSameDomain) {
				context.applicationDomain = ApplicationDomain.currentDomain;
			} else {
				context.applicationDomain =new ApplicationDomain();
			}
			if(source is URLRequest){
				_loader.load(URLRequest(source));
			}else{
				_loader.load(new URLRequest(String(source)),context);
			}
		}
		
		/**
		 * close the load stream.
		 */
		public function close():void{
			_loader.close();
		}
		/**
		 * return the Loader used to load SWF files.
		 * 代表加载SWF文件的Loader。
		 *@return Loader
		 */
		public function get loader():Loader{
			return _loader;
		}
		/**
		 * return the content of the Loader.
		 * 代表Loader的content属性
		 * @return *
		 */
		public function get content():*{
			return _loader.content;
		}
		/**
		 * get a class by name after you loaded the SWF file.
		 * 从加载的SWF文件中获取一个Class。
		 * @param	asset
		 * @return Class
		 */
		public function getClass(asset:String):Class{
			var appDomain:ApplicationDomain=loader.contentLoaderInfo.applicationDomain;
			if(appDomain==null||!appDomain.hasDefinition(asset)){
				return null;
			}
			return appDomain.getDefinition(asset) as Class;
		}
		/**
		 * handle the IO error event while loading a SWF file.
		 * @param	e IOErrorEvent
		 */
		private function onLoaderIOError(e:IOErrorEvent):void{
			e.target.removeEventListener("complete",onLoaderComplete);
			e.target.removeEventListener("init", onLoaderInit);
			e.target.removeEventListener("ioError",onLoaderIOError);
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		/**
		 * handler the complete event while loading a SWF file.
		 * @param	e Event
		 */
		private function onLoaderComplete(e:Event):void{
			e.target.removeEventListener("complete", onLoaderComplete);
			e.target.removeEventListener("ioError",onLoaderIOError);
			dispatchEvent(new Event("complete"));
		}
		/**
		 * hadnle the init event after loading a SWF file.
		 * @param	e Event
		 */
		private function onLoaderInit(e:Event):void{
			e.target.removeEventListener("init",onLoaderInit);
			dispatchEvent(new Event("init"));
		}
	}

}