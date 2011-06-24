package {
	
	/**
	 * @copyright http://colorhook.com
	 */
	 
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.net.URLLoader;
	
	import com.colorhook.spring.context.ContextLoader;
	
	public class Main extends Sprite{
		
		private var contextLoader:ContextLoader;
		private var loader:URLLoader;
		
		public function Main(){
			contextLoader=new ContextLoader();
			contextLoader.addEventListener(Event.COMPLETE,onContextLoaderComplete);
			contextLoader.load("spring-config.xml");
		}
		
		private function onContextLoaderComplete(event:Event):void{
			contextLoader.removeEventListener(Event.COMPLETE,onContextLoaderComplete);
			addChild(contextLoader.contextInfo.getBean('headerBean'));
			loader=contextLoader.contextInfo.getBean('loaderBean') as URLLoader;
			loader.addEventListener(Event.COMPLETE,onLoaderComplete);
		}
		
		private function onLoaderComplete(event:Event):void{
			loader.removeEventListener(Event.COMPLETE,onLoaderComplete);
			var xml:XML=XML(loader.data);
			var nextY:Number=40;
			for each(var status:XML in xml.status){
				var screen_name:String=status..screen_name.toString();
				var text:String=status.text.toString();
				var create_at:String=status.created_at.toString();
				var twitterItem:TwitterItem=new TwitterItem(screen_name,text,create_at);
				twitterItem.x=10;
				twitterItem.y=nextY;
				nextY+=40;
				addChild(twitterItem);
				if(nextY>500){
					break;
				}
			}
		}
	}
}

import flash.text.TextField;
import flash.display.Sprite;

class TwitterItem extends Sprite{
	
	private var textField;
	
	private static const ITEM_W:Number=500;
	private static const ITEM_H:Number=40;
	public function TwitterItem(username:String,status:String,time:String){
		textField=new TextField();
		textField.width=ITEM_W;
		textField.height=ITEM_H;
		textField.wordWrap=true;
		textField.htmlText="<p><b>"+username+": </b>"+status+"  <font size='11' color='#009966'>"+time+"</font></p>";
		addChild(textField);
		
	}
}