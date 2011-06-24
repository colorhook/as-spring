package com.colorhook.spring.context{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;	
	
	
	/**
	 * @author colorhook
	 * @copyright http://www.colorhook.com
	 * 
	 * FlexClassLoader used to load a class from a SWF file created by Flex framework in run-time.
	 */
	 
	 /**
	  * this event dispatched when the SWF flie loaded.
	  */
	[Event(name="complete",type="flash.events.Event")]
	
	
	 /**
	  * this event dispatched when the SWF flie has initialized.
	  */
	[Event(name="init",type="flash.events.Event")]
	
	
	 /**
	  * this event dispatched when the Flex SystemManager  has initialized.
	  */
	[Event(name="applicationComplete",type="flash.events.Event")]
	
	
	
	
	public class FlexClassLoader extends ClassLoader{
		
		
		public static const APPLICATION_COMPLETE:String="applicationComplete";
		
		public function FlexClassLoader(){
			super();
		}
		
		override public function load(source:*,isSameDomain:Boolean=true):void{
			super.load(source,isSameDomain)
			loader.contentLoaderInfo.addEventListener("init",onApplicationInit,false,0,true);
		}
		
		private function onApplicationInit(e:Event):void{
			e.target.removeEventListener("init",onApplicationInit);
			loader.content.addEventListener("applicationComplete",onApplicationComplete,false,0,true);
		}
		
		private function onApplicationComplete(e:Event):void{
			e.target.removeEventListener("applicationComplete",onApplicationComplete);
			dispatchEvent(new Event(APPLICATION_COMPLETE));
		}
		
		
	}

}