package com.colorhook.spring.ioc.vo{
	
	/** 
	 * 
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * @see Bean
	 * ElementBean is value object under the tag beans defined in configuration file
	 * ElementBean 是一个Value Object，代表配置文件中的一个Element Bean。
	 */
	public class ElementBean extends Bean{
		
		public var type:String;
		public var value:String;
		
		/**
		 * Constructor
		 */
		public function ElementBean(){
			
		}
		
		/**
		 * 
		 * @return String
		 */
		override public function toString():String 
		{
			var result:String = "[ElementBean]" + "\t\t";
			result += "id:" + id+"\n";
			result += "value:" + value+"\n";
			result += "type:" + type + "\n";
			result += "singleton:" + singleton + "\n";
			return result;
		}
		
	}
}