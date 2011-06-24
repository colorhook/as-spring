package com.colorhook.spring.ioc.vo{
	
	/**
	 * 
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * Method is value object under the tag methods defined in configuration file
	 * a Method indicate a bean method which execute while you create a bean.
	 * Method是一个Value Object，代表配置文件中的一个方法。
	 */
	public class Method{
		
		public var name:String;
		public var args:Array;

		/**
		 * Constructor
		 * @param	name
		 * @param	args
		 */
		public function Method(name:String=null,args:Array=null){
			this.name=name;
			this.args=args;
		}
		
		/**
		 * 
		 * @return String
		 */
		public function toString():String 
		{
			var result:String = "[Method]" + "\t\t";
			result += "name:" + name+"\t\t";
			result += "args:" + args+"\t\t";
			return result;
		}
		
	}
}