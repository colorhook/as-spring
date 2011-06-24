package com.colorhook.spring.ioc.vo{
	
	/**
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * Argument is value object indicate a constructor argument.
	 * Argument 是一个Value Object，代表函数的一个参数。
	 */

	public class Argument{
		

		public var type:String;
		public var value:String;
		public var ref:String;
		public var bean:*;
		
		/**
		 * Constructor
		 * @param value
		 * @param type
		 * @param ref
		 * @param bean
		 */
		public function Argument(value:String=null,type:String=null,ref:String=null,bean:*=null){
			this.value=value;
			this.type = type;
			this.ref = ref;
			this.bean=bean;
		}
		
		/**
		 * 
		 * @return	String
		 */
		public function toString():String 
		{
			var result:String = "[Argument]" + "\t\t";
			result += "value:" + value+"\t\t";
			result += "type:" + type + "\t\t";
			result += "ref:" + ref+"\t\t";
			result += "bean:" + bean+"\t\t";
			return result;
		}
	}
}