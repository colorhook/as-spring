package com.colorhook.spring.context{
	
	/**
	 * @author  colorhook
	 * @copyright http://www.colorhook.com
	 *
	 */
	 
	import flash.utils.Dictionary;
	
	/**
	 * ObjectPool is used in class ContextInfo to cache the bean which is a singleton.
	 *
	 * ObjectPool类是一个对象池，用来保存对象的引用。
	 * 在配置文件中，如果一个Bean被指定为singleton，那么这个Bean在创建后会注册到ObjectPool中。
	 * 使用ContextInfo.getBean(id)来创建一个bean时，会首先查找ObjectPool中是否包含改Bean，如果是则返回ObjectPool中
	 * 的Bean，否则会重新生成一个Bean。
	 *
	 * @see ContextInfo
	 */
	public class ObjectPool{
		
		/**
		 * The map of the all objects.
		 * 代表对象的字典，所有添加到对象池对象都可以在其中查到。
		 */
		protected var pool:Dictionary;
		
		/**
		 *@constructor
		 * Constructor
		 * 构造器
		 */
		public function ObjectPool(){
			pool=new Dictionary(true);
		}
		
		/**
		 * add a object to the pool and use a name to identify.
		 * 添加一个对象到对象池，并以一个name做标记。
		 * @param	name The identity of the object.
		 * 代表对象的标记
		 * @param	obj a object 
		 */
		public function add(name:String,obj:*):void{
			if(contains(name)){
				throw new Error("There has a object in the pool already.");
			}
			pool[name]=obj;
		}
		/**
		 * remove the object in the pool by name.
		 * 移出一个对象。
		 * @param	name The identity of the object.
		 * 代表对象的标记
		 */
		public function remove(name:String):void{
			delete pool[name];
		}
		/**
		 * remove all the object in the pool.
		 * 移出所有对象。
		 */
		public function removeAll():void{
			pool=new Dictionary;
		}
		/**
		 * check if the pool contains a special name object.
		 * 
		 * @param	name The identity of the object.
		 * 代表对象的标记
		 * @return
		 */
		public function contains(name:String):Boolean{
			return pool[name]!==undefined;
		}
		/**
		 * get the object in the pool by name.
		 * 取出一个对象。
		 * @param	name The identity of the object.
		 * 代表对象的标记
		 * @return
		 */
		public function get(name:String):*{
			return pool[name];
		}
		
	}
}