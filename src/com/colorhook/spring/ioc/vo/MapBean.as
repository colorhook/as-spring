package com.colorhook.spring.ioc.vo{
	
	/** 
	 * 
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * MapBean is dictionary object under the tag beans defined in configuration file
	 * MapBean 是一个Dictionary Object，代表配置文件中的一个Map Bean。
	 */
	public class MapBean extends Bean{
		
		public var elements:Array=[];
		public var weakKeys:Boolean;
		/**
		 * Constructor
		 */
		public function MapBean(){
			
		}
		
		/**
		 * 
		 * @return String
		 */
		override public function toString():String 
		{
			var result:String = "[DictionaryBean]" + "\t\t";
			result += "id:" + id+"\n";
			result += "singleton:" + singleton + "\n";
			result += "elements:" + elements + "\n";
			return result;
		}
		
	}
}