package com.colorhook.spring.ioc.vo{
	
	/** 
	 * 
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * ListBean is array object under the tag beans defined in configuration file
	 * ListBean 是一个Value Object，代表配置文件中的一个List Bean。
	 */
	public class ListBean extends Bean{
		
		public var elements:Array;
		
		/**
		 * Constructor
		 */
		public function ListBean(){
			
		}
		
		/**
		 * 
		 * @return String
		 */
		override public function toString():String 
		{
			var result:String = "[ArrayBean]" + "\t\t";
			result += "id:" + id+"\n";
			result += "singleton:" + singleton + "\n";
			result += "elements:" + elements + "\n";
			return result;
		}
		
	}
}