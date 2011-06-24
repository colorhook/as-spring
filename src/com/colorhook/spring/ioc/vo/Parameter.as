package com.colorhook.spring.ioc.vo{
	
	/**
	 *
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * Parameter is value object under the tag params defined in configuration file
	 * Parameter 是一个Value Object，代表配置文件中的一个参数。
	 */
	
	public class Parameter{
		
		public var name:String;
		public var type:String;
		public var value:String;

		/**
		 * Constructor
		 * @param	name
		 * @param	value
		 * @param	type
		 */
		public function Parameter(name:String=null,value:String=null,type:String=null){
			this.name=name;
			this.value=value;
			this.type=type;
		}
		
		/**
		 * 
		 * @return String
		 */
		public function toString():String 
		{
			var result:String = "[Parameter]" + "\t\t";
			result += "name:" + name+"\t\t";
			result += "type:" + type+"\t\t";
			result += "value:" + value+"\t\t";
			return result;
		}
	}
}