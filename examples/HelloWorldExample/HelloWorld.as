package {
	
	/**
	 * @copyright http://www.colorhook.com
	 */
	 
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import com.colorhook.spring.context.ContextLoader;
	
	public class HelloWorld extends Sprite{
		
		protected var textField:TextField;
		private var contextLoader:ContextLoader;
		
		public function HelloWorld(){
			contextLoader=new ContextLoader();
			contextLoader.addEventListener(Event.COMPLETE,onContextLoaderComplete);
			contextLoader.load("spring-config.xml");
		}
		
		private function onContextLoaderComplete(event:Event):void{
			contextLoader.removeEventListener(Event.COMPLETE,onContextLoaderComplete);
			textField= contextLoader.contextInfo.getBean('textFieldBean') as TextField;
			addChild(textField);
		}
	}
}