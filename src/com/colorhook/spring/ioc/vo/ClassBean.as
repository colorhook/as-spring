package com.colorhook.spring.ioc.vo{
	
	/** 
	 * 
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * @see Bean
	 * ClassBean is value object under the tag beans defined in configuration file
	 * ClassBean 是一个Value Object，代表配置文件中的一个Class Bean。
	 */
	public class ClassBean extends Bean{
		
		public var className:String;
		public var class_ref:String;
		public var factoryMethod:String;
		public var factoryBean:String;
		public var constructor_arg:Array=[];
		public var properties:Array=[];
		public var methods:Array=[];
		
		/**
		 * 
		 * @return String
		 */
		override public function toString():String 
		{
			var result:String = "[ClassBean]" + "\t\t";
			result += "id:" + id+"\n";
			result += "className:" + className+"\n";
			result += "class_ref:" + class_ref + "\n";
			result += "factoryMethod:" + factoryMethod + "\n";
			result += "factoryBean:" + factoryBean + "\n";
			result += "singleton:" + singleton + "\n";
			result += "constructor_arg:" + constructor_arg + "\n";
			result += "properties:" + properties + "\n";
			result += "methods:" + methods + "\n";
			return result;
		}
		
	}
}