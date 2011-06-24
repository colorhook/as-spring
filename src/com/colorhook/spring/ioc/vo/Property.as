package com.colorhook.spring.ioc.vo{
	
	/**
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * Property is value object which under the tag bean defined in configuration file.
	 * a Property indicate a bean property.
	 * Property 是一个Value Object，代表配置文件中的Bean的属性。
	 */
	
	public class Property{
		
		public var name:String;
		public var type:String;
		public var value:String;
		public var ref:String;
		public var bean:*;
		public var properties:Array;
		public var methods:Array;
		
		
		/**
		 * Constructor
		 * @param name
		 * @param value
		 * @param type
		 * @param ref
		 * @param Bean
		 */
		public function Property(name:String=null,value:String=null,type:String=null,ref:String=null,bean:*=null){
			this.name=name;
			this.value=value;
			this.type=type;
			this.ref=ref;
			this.bean=bean;
		}
		
		/**
		 * 
		 * @return String
		 */
		public function toString():String 
		{
			var result:String = "[Property]" + "\t\t";
			result += "name:" + name+"\t\t";
			result += "type:" + type+"\t\t";
			result += "value:" + value+"\t\t";
			result += "ref:" + ref+"\t\t";
			result += "bean:" + bean+"\t\t";
			return result;
		}
		
	}
}