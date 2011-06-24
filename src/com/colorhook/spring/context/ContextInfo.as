package com.colorhook.spring.context{

	/**
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 */
	
	import flash.utils.Dictionary;
	import flash.system.ApplicationDomain;

	import com.colorhook.spring.ioc.vo.*;
	import com.colorhook.spring.utils.*;
	import com.colorhook.spring.context.ObjectPool;
	import com.colorhook.spring.ioc.ValueBuilder;

	/**
	 * ContextInfo is a core class to implement the IOC/DI pattern.
	 * you need get a instance from class ContextLoader, rather than create a new instance by youself.
	 * @example
	 * <pre>
	 *
	 * var contextInfo:ContextInfo;
	 * var contextLoader:ContextLoader;
	 * contextLoader.addEventListener("complete",initApp);
	 * contextLoader.load("spring_config.xml");
	 *
	 * function initApp(e:Event){
	 *	contextInfo=ContextLoader.contextInfo;;
	 *	var sound:Sound=contextInfo.getBean("sound");
	 *	sound.play();
	 * }
	 * </pre>
	 *
	 * @see ContextLoader
	 */
	public class ContextInfo {

		private var _classMap:Dictionary;
		private var _beanMap:Dictionary;
		private var _LibMap:Dictionary;
		
		/**
		 *
		 * Object pool is use to cache the bean be created and which is a singleton also.
		 */
		protected var objectPool:ObjectPool;

		/**
		 * @constructor
		 * 构造器
		 */
		public function ContextInfo() {
			_classMap=new Dictionary();
			_beanMap=new Dictionary();
			_LibMap=new Dictionary();
			objectPool=new ObjectPool();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////
		//public methods
		////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * This is a useful method to get a library defined in the configuration file.
		 * 通过库名称来获取配置文件中的库，类型一般是MovieClip。
		 * @param	name The name of a library defined in the configuraition file.
		 * 定义在配置文件中的库名称。
		 * @return *
		 */
		public function getLib(name:String):* {
			return _LibMap[name];
		}
		/**
		 * Check by name to know if this contains a library.
		 * 通过名称检查是否包含该库。
		 * @param	name The name of a library defined in the configuration file.
		 * 定义在配置文件中的库名称。
		 * @return Boolean
		 */
		public function containsLib(name:String):Boolean {
			return _LibMap[name] != null;
		}
		/**
		 * This is a useful method to get a class defined in the configuration file.
		 * 通过类名称来获取配置文件中的类。
		 * @param	name The name of a Class defined in the configuration file.
		 * 定义在配置文件中的类名称。
		 * @return Class
		 */
		public function getClass(name:String):Class {
			var clazz:Class=_classMap[name] as Class;
			if (clazz!=null) {
				return clazz;
			}

			return ClassUtil.getClass(name);
		}
		/**
		 * Check by name to know if this contains a Class.
		 * 通过名称检查是否包含该类。
		 * @param	name The name of a Class defined in the configuration file.
		 * 定义在配置文件中的类名称。
		 * @return Boolean
		 */
		public function containsClass(name:String):Boolean {
			return _classMap[name] != null;
		}
		/**
		 * This is the most important method to use this class.
		 * By this method, you can create a instance defined in the configuration file.	 
		 * 通过Bean名称来获取配置文件中的Bean。
		 * 你可以通过这个方法来实现IOC/DI模式。
		 *
		 * @see ContextLoader
		 * 
		 * @param	id the id of a bean defined in the configuration file.
		 ** 定义在配置文件中的Bean ID。
		 * @return *
		 */
		public function getBean(id:String):* {
			if (!containsBean(id)) {
				return null;
			}
			var bean:Bean=_beanMap[id];
			return instantiateBean(bean);
		}
		/**
		 * Check by id if this contains a bean.
		 * 通过id检查是否包含该Bean。
		 * @param	id The id of a bean.
		 * @return Booelan
		 */
		public function containsBean(id:String):Boolean{
			return _beanMap[id]!=null;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////
		//private methods
		////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * create a instance by a bean id, there are three case to create a bean.
		 * 1. new      ==>	<code>var instance=new clazz(...arg);</code>
		 * 2. static   ==>	<code>var instance=Singleton.getInstance(...arg);</code>
		 * 3. factory  ==>	<code>var instance=otherInstance.createObject(...arg);</code>
		 * 
		 * @param	id : String  
		 * @return
		 */
		
		protected function instantiateBean(bean:Bean):*{
			var instance:*;
			if (bean.singleton && objectPool.contains(bean.id)) {
				instance=objectPool.get(bean.id);
				return instance;
			} else {
				instance=createNewBean(bean);
			}
			if (bean.singleton) {
				objectPool.add(bean.id,instance);
			}
			return instance;
		}
		private function createNewBean(bean:Bean):* {
			if (bean is ElementBean) {
				return instantiateElementBean(ElementBean(bean));
			}else if(bean is ClassBean){
				return instantiateClassBean(ClassBean(bean));
			}else if (bean is MapBean) {
				return instantiateMapBean(MapBean(bean));
			}else if (bean is ListBean) {
				return instantiateListBean(ListBean(bean));
			}
			return null;
		}
		protected function instantiateElementBean(bean:ElementBean):*{
			return ValueBuilder.getValue(bean.value, bean.type);
		}
		protected function instantiateListBean(bean:ListBean):*{
			var array:Array = [];
			if (!bean.elements) {
				return array;
			}
			for(var i:int=0, l:int=bean.elements.length; i < l; i++){
				array.push(instantiateBean(bean.elements[i]));
			}
			return array;
		}
		protected function instantiateMapBean(bean:MapBean):*{
			var map:*={};
			for(var i:int=0, l:int=bean.elements.length; i < l; i++){
				var v:*=bean.elements[i];
				var key:String=v.key;
				var keyValue:*;
				if(v.bean){
					keyValue=instantiateBean(v.bean);
				}else if(v.ref){
					keyValue=getBean(v.ref);
				}else{
					keyValue = ValueBuilder.getValue(v.value, v.type);
				}
				map[key]=keyValue;
			}
			return map;
		}

		protected function instantiateClassBean(bean:ClassBean):*{
			var instance:*;
			if (bean.factoryMethod!=null&&bean.factoryMethod!="") {
				if (bean.factoryBean!=null&&bean.factoryBean!="") {
					instance=ClassUtil.createFactoryInstance(getBean(bean.factoryBean),bean.factoryMethod,getBeanArguments(bean));
				} else {
					instance=ClassUtil.createFactoryInstance(getBeanClassByName(bean),bean.factoryMethod,getBeanArguments(bean));
				}
			} else {
				instance=ClassUtil.createInstance(getBeanClassByName(bean),getBeanArguments(bean));
			}
			if (instance) {
				setupProperties(instance,bean.properties);
				setupMethods(instance,bean.methods);
			}
			return instance;
		}
		/**
		 * return the type of a bean.
		 * @param	id String
		 * @return Class
		 */
		private function getBeanClassByName(bean:ClassBean):Class {
			var className:String=(bean.className!=null)?bean.className:bean.class_ref;
			if (className==null) {
				return Object;
			}
			return getClass(className);
		}
		/**
		 * create the arguments by the bean id.
		 * @param	id String
		 * @return Array
		 */
		private function getBeanArguments(bean:ClassBean):Array {
			var arguments:Array=bean.constructor_arg;
			var result:Array=new Array;
			for (var i:int=0; i<arguments.length; i++) {
				result.push(getArgumentValue(arguments[i]));
			}
			return result;
		}
		/**
		 * set target properties with chain-style.
		 * @param	target *
		 * @param	props Array<Property>
		 */
		private function setupProperties(target:Object,props:Array):void {
			for (var i:int=0; i<props.length; i++) {
				setupProperty(target,props[i] as Property);
			}
		}
		/**
		 * execute target methods 
		 * @param	target *
		 * @param	methods : Array<Method>
		 */
		private function setupMethods(target:Object,methods:Array):void {
			for (var i:int=0; i<methods.length; i++) {
				setupMethod(target,methods[i] as Method);
			}
		}
		/**
		 * set target property with chain-style.
		 * @param	target *
		 * @param	property Property
		 */
		private function setupProperty(target:Object,property:Property):void {
			setTargetProperty(target,property.name,getPropertyValue(property));
			if (!target.hasOwnProperty(property.name)) {
				return;
			}
			if (property.properties!=null&&property.properties.length>0) {
				setupProperties(target[property.name],property.properties);
			}
			if (property.methods!=null&&property.methods.length>0) {
				setupMethods(target[property.name],property.methods);
			}
		}
		/**
		 * execute target method.
		 * @param	target *
		 * @param	method Method
		 */
		private function setupMethod(target:Object,method:Method):void {
			var invoker:*=target[method.name];
			if (invoker is Function) {
				var args:Array=new Array;
				for (var i:int=0; i<method.args.length; i++) {
					args.push(getArgumentValue(method.args[i]));
				}
				invoker.apply(target,args);
			}
		}
		/**
		 * set target property
		 * @param	target *
		 * @param	name String
		 * @param	value *
		 */
		private function setTargetProperty(target:Object,name:String,value:Object):void {
			try {
				target[name]=value;
			} catch (e:Error) {
			}
		}
		/**
		 * get a resonable peoperty value.
		 * @param	property
		 * @return
		 */
		private function getPropertyValue(property:Property):* {
			if(property.bean){
				return instantiateBean(property.bean);
			}
			if (property.ref) {
				return getBean(property.ref);
			}
			return ValueBuilder.getValue(property.value,property.type);
		}
		/**
		 * get a resonable argument value.
		 * @param	argument
		 * @return
		 */
		private function getArgumentValue(argument:Argument):* {
			if(argument.bean){
				return instantiateBean(argument.bean);
			}
			if (argument.ref) {
				return getBean(argument.ref);
			}
			return ValueBuilder.getValue(argument.value,argument.type);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////
		//internal methods
		////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * Internal Method
		 * 内部方法
		 *
		 * cache a library to this and you could retrieve it later.
		 * 将一个对象（通常是一个MovieClip）注册到类库列表。
		 * @param	name String
		 * @param	library *
		 */
		internal function cacheLib(name:String,library:Object):void {
			_LibMap[name]=library;
		}
		
		/**
		 * Internal Method
		 * 内部方法
		 *
		 * cache a class to this and you could retrieve it later.
		 * 将一个Class注册到Class列表。
		 * @param	name String
		 * @param	classRef Class
		 */
		internal function cacheClass(name:String,classRef:Class):void {
			_classMap[name]=classRef;
		}
		
		/**
		 * Internal Method
		 * 内部方法
		 *
		 * cache a bean to this and you could create a instance later.
		 * 将一个Bean注册到Bean列表。
		 * @param	bean Bean
		 */
		internal function cacheBean(bean:Bean):void {
			_beanMap[bean.id]=bean;
		}

	}

}