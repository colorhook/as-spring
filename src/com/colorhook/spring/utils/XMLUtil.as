package com.colorhook.spring.utils{
	
	/**
	 * @author colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * The XMLUtil class is an all-static class
	 * You should not create instances of XMLUtil;
	 * XMLUtil是一个静态类。
	 */
	public class XMLUtil{
		
		public function XMLUtil(){
			throw new Error("XMLUtil is a static class.");
		}
		
		/**
		 * check if a xml has a atrribute by name;
		 * 检查是否有该名称的属性。
		 * @param	xml
		 * @param	name
		 * @return Boolean
		 */
		public static function hasAttribute(xml:XML, name:String):Boolean{
			return xml.@[name].length()>0;
		}
		/**
		 * check if a xml has a node by name.
		 * 返回该名称属性的值。
		 * @param	xml
		 * @param	name
		 * @return Boolean
		 */
		public static function hasNode(xml:XML, name:String):Boolean{
			return xml.child(name).length()>0;
		}
		
		/**
		 * get a xml attribute value by name, return null if the attibute not exist.
		 * 检查是否有该名称的节点。
		 * @param	xml
		 * @param	name
		 * @return String
		 */
		public static function getAttribute(xml:XML, name:String):String{
			if(xml.@[name].length()==0){
				return null;
			}
			return xml.@[name].toString();
		}
		/**
		 * get a xml node value by name, return null if the node not exist.
		 * 返回该名称节点的内容。
		 * @param	xml
		 * @param	name
		 * @return String
		 */
		public static function getNode(xml:XML,name:String):String{
			if(xml.child(name).length()==0){
				return null;
			}
			return xml.child(name).toString();
		}
		
	}
}