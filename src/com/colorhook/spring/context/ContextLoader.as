package com.colorhook.spring.context{

	/**
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 */
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import com.colorhook.spring.ioc.vo.*;
	import com.colorhook.spring.ioc.SpringConstant;
	import com.colorhook.spring.utils.ClassUtil;
	import com.colorhook.spring.utils.XMLUtil;
	import com.colorhook.spring.context.ContextInfo;
	import com.colorhook.spring.context.ClassLoader;
	
	
	/**
	 * After the configuration file loaded, libraries loaded and contextInfo initialized, the event dispatched.
	 * 配置文件加载完成，配置文件中的类加载完成并且contextInfo初始化之后发出该事件。
	 */
	[Event(name="complete",type="flash.events.Event")];

	/**
	 * ContextLoader is used to load a spring configuration file.
	 * you need to handler the 'complete' event to setup your application.
	 * 
	 * @example
	 *
	 * <pre>
	 *
	 * var contextLoader:ContextLoader=new ContextLoader();
	 * var myBean:*;
	 * contextLoader.addEventListener("complete",onContextLoaderComplete);
	 * contextLoader.load("spring_config.xml");
	 *
	 * function onContextLoaderComplete(e:Event):void{
	 * 		myBean=contextLoader.contextInfo.getBean("myBeanName");
	 * }
	 *
	 * </pre>
	 * 
	 */
	public class ContextLoader extends EventDispatcher {
		
		/**
		 * Dafault path of the configuration file.
		 * 默认的配置文件路径。
		 */
		public static  const CONFIG_PATH:String="spring_config.xml";

		/**
		 * represent the data of the configuration file.
		 * 代表配置文件的数据。
		 */
		protected var data:*;
		
		private var configFiles:Array=[];
		private var configFileIndex:int=0;
		private var configFilesAllReady:Boolean=false;
		
		private var _contextInfo:ContextInfo;
		private var loadCounter:Number;
		private var loaderArr:Array;
		
		/**
		 * @contructor	ContextLoader
		 * 构造器
		 */
		public function ContextLoader() {
			_contextInfo=new ContextInfo();
		}
		
		/**
		 * start to load a configuration file.
		 * 加载一个配置文件
		 * 参数可以为空，类型可以是String或者URLRequest。如果为空会以默认的文件地址CONFIG_PATH来查找配置文件。
		 * @param	source path of the spring configuration file default null.
		 * 
		 */
		public function load(source:*=null):void {
			if (source==null) {
				source=CONFIG_PATH;
			}
			configFiles.push(source);
			loadNextConfigFile();
		}
		
		private function loadNextConfigFile():void{
			var configFile:*=configFiles[configFileIndex];
			var configURLLoader:URLLoader=new URLLoader;
			configURLLoader.addEventListener("complete", onConfigFileLoaded);
			configURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			if(configFile is URLRequest){
				configURLLoader.load(URLRequest(configFile));
			}else{
				configURLLoader.load(new URLRequest(String(configFile)));
			}
		}
		/**
		 * handle the IO error event while loading the configuration file.
		 * @param	e IOrrorEvent
		 */
		private function onIOError(e:IOErrorEvent) :void{
			e.target.removeEventListener(Event.COMPLETE, onConfigFileLoaded);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			throw new IOError("Can't load the configuartion file.");
		}
		/**
		 * handle the complete event while loading the configuraiton file.
		 * @param	e : Event
		 */
		private function onConfigFileLoaded(e:Event):void {
			e.target.removeEventListener("complete", onConfigFileLoaded);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			data = e.target.data;
			var imports:XMLList=XML(data).child(SpringConstant.IMPORT).@[SpringConstant.RESOURCE];
			
			for(var i:int=0;i<imports.length();i++){
				var file:String=imports[i].toString();
				if(file&&configFiles.indexOf(file)<0){
					configFiles.push(file);
				}
			}
			if(++configFileIndex>=configFiles.length){
				configFilesAllReady=true;
			}
			parse();
		}
		/**
		 * parse the configuration file.
		 * 配置文件加载完成后处理配置文件。
		 * you would extend ContextLoader to get more functions and you could override this method.
		 */
		protected function parse():void {
			loadLibs();
		}
		/**
		 * 
		 * parse the data and initialize the contextInfo.
		 * 解析配置文件数据到contextInfo
		 */
		protected function initializeContextInfo():void {
			var xml:XML = XML(data);
			var classList:XMLList = xml.child(SpringConstant.CLASSES).child(SpringConstant.CLASS);
			var item:*;
			/////////////////////////////////////////////////////////////////////////
			//parse libs
			for each (item in loaderArr) {
				_contextInfo.cacheLib(item.name, item.loader.content);
			}
			/////////////////////////////////////////////////////////////////////////
			//parse classes
			for each (item in classList) {
				var cName:String = XMLUtil.getAttribute(item, SpringConstant.NAME);
				var cClass:String=XMLUtil.getAttribute(item, SpringConstant.CLASS);
				var cLib:String=XMLUtil.getAttribute(item, SpringConstant.LIB);
				var clazz:Class;
				if (cLib!=null&&cLib!="") {
					var mc:MovieClip=_contextInfo.getLib(cLib);
					clazz = ClassUtil.getClassByMovieClip(cClass, mc);
				}
				if(clazz==null){
					clazz=ClassUtil.getClass(cClass);
				}
				if(clazz){
					_contextInfo.cacheClass(cName,clazz);
				}
			}
			/////////////////////////////////////////////////////////////////////////
			//parse beans
			var beans:Array=getBeansUnderNode(xml.child(SpringConstant.BEANS)[0]);
			for (var i:int = 0, l:int = beans.length; i < l; i++) {
				_contextInfo.cacheBean(beans[i]);
				
			}
		}
		/**
		 * 从XML中解析一个ElementBean
		 */
		private function getElementBeanByXML(item:XML):ElementBean {
			var bean:ElementBean = new ElementBean;
			bean.id = XMLUtil.getAttribute(item, SpringConstant.ID);
			bean.value = getValueByXML(item);
			bean.type = XMLUtil.getAttribute(item, SpringConstant.TYPE);
			bean.singleton = XMLUtil.getAttribute(item, SpringConstant.SINGLETON) == "true" ;
			return bean;
		}
		/**
		 * 从XML中解析一个ClassBean
		 */
		private function getClassBeanByXML(item:XML):ClassBean{
			var bean:ClassBean = new ClassBean();
			bean.id = XMLUtil.getAttribute(item, SpringConstant.ID);
			bean.className = XMLUtil.getAttribute(item, SpringConstant.CLASS);
			bean.class_ref = XMLUtil.getAttribute(item, SpringConstant.CLASS_REF);			
			bean.factoryBean = XMLUtil.getAttribute(item, SpringConstant.FACTORY_BEAN);
			bean.factoryMethod = XMLUtil.getAttribute(item, SpringConstant.FACTORY_METHOD);
			bean.singleton = XMLUtil.getAttribute(item, SpringConstant.SINGLETON) == "true" ;
			/////////////////////////////////////////////////////////
			///////////////////////////////set constructor arguments
			var beanArgs:Array = getArgumentsByXMLList(item.child(SpringConstant.CONSTRUCTOR_ARG));
			bean.constructor_arg = beanArgs;
			
			/////////////////////////////////////////////////////////
			///////////////////////////////set properties
			var beanProps:Array = getPropertiesByXMLList(item.child(SpringConstant.PROPERTY));
			bean.properties = beanProps;
			
			/////////////////////////////////////////////////////////
			///////////////////////////////set methods
			var methods:Array = getMethodsByXMLList(item.child(SpringConstant.METHOD));
			bean.methods = methods;
			return bean;
			
		}
		/**
		 * 从XML中解析一个ListBean
		 */
		private function getListBeanByXML(item:XML):ListBean{
			var bean:ListBean=new ListBean();
			bean.id = XMLUtil.getAttribute(item, SpringConstant.ID);
			bean.singleton = XMLUtil.getAttribute(item, SpringConstant.SINGLETON) == "true" ;
			var eles:Array=[];
			for each(var child:XML in item.children()){
				eles.push(analyAndGetBeanByXML(child));
			}
			bean.elements=eles;
			return bean;
		}
		/**
		 * 从XML中解析一个MapBean
		 */
		private function getMapBeanByXML(item:XML):MapBean{
			var bean:MapBean=new MapBean();
			bean.id = XMLUtil.getAttribute(item, SpringConstant.ID);
			bean.singleton = XMLUtil.getAttribute(item, SpringConstant.SINGLETON) == "true" ;
			var eles:Array=[];
			for each(var child:XML in item.children()){
				var nodeName:String=String(child.name());
				if(nodeName==SpringConstant.KEY){
					var keyName:String=XMLUtil.getAttribute(child, SpringConstant.NAME);
					var childBean:Bean = getBeansUnderNode(child)[0];
					if (childBean&&childBean.id&&childBean.id!="") {
						_contextInfo.cacheBean(childBean);
					}
					eles.push({key:keyName, 
							bean:childBean, 
							value:getValueByXML(child),
							type:XMLUtil.getAttribute(child, SpringConstant.TYPE),
							ref:getRefByXML(child)});
				}
			}
			bean.elements=eles;
			return bean;
		}
		/**
		 * 从XML中解析出一个Bean的数组，数组元素可以是ElementBean、ClasBean、ListBean、MapBean
		 */
		private function getBeansUnderNode(node:XML):Array {
			if (node.length == 0) {
				return [];
			}
			var beans:Array = [];
			for each(var child:XML in node.children()){
				var bean:*=analyAndGetBeanByXML(child);
				if(bean){
					beans.push(bean);
				}
				
			}
			return beans;
		}
		/**
		 * 从XML中解析出一个Bean的子类
		 */
		private function analyAndGetBeanByXML(item:XML):Bean{
			var nodeName:String = item.name();
			if (nodeName == SpringConstant.ELEMENT) {
				return getElementBeanByXML(item);
			}else if(nodeName==SpringConstant.BEAN){
				return getClassBeanByXML(item);
			}else if(nodeName==SpringConstant.LIST){
				return getListBeanByXML(item);
			}else if(nodeName==SpringConstant.MAP){
				return getMapBeanByXML(item);
			}
			return null;
		}
		/**
		 * get the 'value' attribute or 'value' node.
		 * @param	xml
		 * @return
		 */
		private function getValueByXML(xml:XML):String {
			if (XMLUtil.hasNode(xml, SpringConstant.VALUE)) {
				return XMLUtil.getNode(xml, SpringConstant.VALUE);
			}else {
				return XMLUtil.getAttribute(xml, SpringConstant.VALUE);
			}
		}
		/**
		 * get the 'ref' attribute or 'ref' node.
		 * @param	xml
		 * @return String
		 */
		private function getRefByXML(xml:XML):String {
			if (XMLUtil.hasNode(xml, SpringConstant.REF)) {
				return XMLUtil.getAttribute(xml.child(SpringConstant.REF)[0], SpringConstant.VALUE);
			}else {
				return XMLUtil.getAttribute(xml, SpringConstant.REF);
			}
		}
		/**
		 * 从XMLList解析为一个数组作为Arguments
		 * @param	xmllist
		 * @return Array
		 */
		private function getArgumentsByXMLList(xmllist:XMLList):Array {
			var arguments:Array = new Array();
			for each(var argument:* in xmllist) {
				var argValue:String = getValueByXML(argument);
				var argRef:String=getRefByXML(argument);
				var argType:String = XMLUtil.getAttribute(argument, SpringConstant.TYPE)
				var argBeans:Array=getBeansUnderNode(argument);
				if(argBeans.length > 0){
					var argBean:ClassBean=argBeans[0];
					if(argBean.id!=null&&argBean.id!=""){
						_contextInfo.cacheBean(argBean);
					}
				}
				
				arguments.push(new Argument(argValue, argType, argRef, argBean));
			}
			return arguments;
		}
		/**
		 * 从XMLList解析为一个数组作为Properties
		 * @param	xmllist
		 * @return Array
		 */
		private function getPropertiesByXMLList(xmllist:XMLList):Array {
			var properties:Array = new Array();
			for each(var property:* in xmllist) {
				
				var pName:String = XMLUtil.getAttribute(property, SpringConstant.NAME);
				
				var pType:String=XMLUtil.getAttribute(property, SpringConstant.TYPE);
				var pValue:String=getValueByXML(property);
				var pRef:String = getRefByXML(property);
				
				var pBean:*=getBeansUnderNode(property)[0];
				
				if(pBean&&pBean.id!=null&&pBean.id!=""){
					_contextInfo.cacheBean(pBean);
				}

				var prop:Property = new Property(pName, pValue, pType, pRef, pBean);
				prop.properties = getPropertiesByXMLList(property.child(SpringConstant.PROPERTY));
				prop.methods = getMethodsByXMLList(property.child(SpringConstant.METHOD));
				properties.push(prop);
			}
			
			return properties;
			
		}
		/**
		 * create a method array form xml;
		 * @param	xml
		 * @return Array
		 */
		private function getMethodsByXMLList(xml:XMLList):Array {
			var methods:Array = new Array;
			for each(var method:* in xml) {
				
				var methodName:String = XMLUtil.getAttribute(method, SpringConstant.NAME) ;
				var methodArg:Array = getArgumentsByXMLList(method.child(SpringConstant.METHOD_ARG));
				methods.push(new Method(methodName, methodArg));
			}
			return methods;
		}
		
		/**
		 * load the libraries defined in configuration file.
		 */
		private function loadLibs():void {
			var libList:XMLList=XML(data).child(SpringConstant.LIBS).child(SpringConstant.LIB);
			loadCounter = libList.length();
			checkLibComplete();
			loaderArr=new Array;
			for each (var item:* in libList) {
				var libName:String=XMLUtil.getAttribute(item,SpringConstant.NAME); 
				var path:String =XMLUtil.getAttribute(item,SpringConstant.PATH); 
				var loader:ClassLoader = new ClassLoader();
				if(libName&&path){
					var sameDomain:Boolean = XMLUtil.getAttribute(item, SpringConstant.SAME_DOMAIN) != "false";
					loader.addEventListener(Event.INIT, libraryLoaded);
					loader.addEventListener("ioError", libraryIOError,false,0,true);
					try{
						loader.load(path,sameDomain);
					}catch(e:Error){
						loadCounter--;
					}
					loaderArr.push({name:libName,loader:loader});
				}
			}
		}
		/**
		 * handle the IO error event while loading the library.
		 * @param	e IOErrorEvent
		 */
		private function libraryIOError(e:IOErrorEvent):void {
			loadCounter-=1;
			checkLibComplete()
			e.currentTarget.removeEventListener(Event.INIT, libraryLoaded);
			e.currentTarget.removeEventListener("ioError", libraryLoaded);
		}
		/**
		 * handle the complete event while loading the library.
		 * @param	e Event
		 */
		private function libraryLoaded(e:Event):void {
			loadCounter-=1;
			checkLibComplete();
			e.currentTarget.removeEventListener(Event.INIT, libraryLoaded);
			e.currentTarget.removeEventListener("ioError", libraryLoaded);
		}
		/**
		 * check if the all libraries have been loaded.
		 * if have than dispatch the complete event.
		 */
		private function checkLibComplete():void {
			if (loadCounter <= 0) {
				initializeContextInfo();
				if(!configFilesAllReady){
					loadNextConfigFile();
				}else{
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		/**
		 * indicate the contextInfo which is a instance of a core class ContextInfo.
		 * you need use contextInfo to get parameters, classes and beans.
		 * @readonly 
		 *
		 * 只读属性，在加载完成之后你需要从contextInfo来获取配置文件中的参数，类和Bean。
		 */
		public function get contextInfo():ContextInfo {
			return _contextInfo;
		}
		
	}
}
