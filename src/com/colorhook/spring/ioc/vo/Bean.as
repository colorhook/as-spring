package com.colorhook.spring.ioc.vo{
	
	/** 
	 * 
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * Bean is value object under the tag beans defined in configuration file
	 * Bean 是一个Value Object，该类是一个抽象类，配置文件中的Bean都是它的子类。
	 */
	public class Bean{
		
		public var id:String;
		public var singleton:Boolean;
		
		/**
		 * Constructor
		 */
		public function Bean(){
			
		}
		
		/**
		 * 
		 * @return String
		 */
		public function toString():String 
		{
			var result:String = "[Bean]" + "\t\t";
			result += "id:" + id+"\n";
			result += "singleton:" + singleton + "\n";
			return result;
		}
		
	}
}