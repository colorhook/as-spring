package com.colorhook.spring.utils{
	
	/**
	 * @author colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * The ClassUtil class is an all-static class
	 * You should not create instances of ClassUtil;
	 * ClassUtil是一个静态类。
	 */
	 
	import flash.system.ApplicationDomain;
	import flash.display.MovieClip;
	
	public class ClassUtil{
		
		public function ClassUtil(){
			throw new Error("ClassUtil is a static class.");
		}
		/**
		 * get a class by name in a specify application domain.
		 * 从指定的应用域中取得一个Class。
		 *
		 * @param	name : String
		 * @param	applicationDomain : ApplicationDomain
		 * @return Class
		 */
		public static function getClass(name:String,applicationDomain:ApplicationDomain=null):Class{
			var result:Class;
			if(!applicationDomain)
			applicationDomain=ApplicationDomain.currentDomain;
			
			while(!applicationDomain.hasDefinition(name)){
				if(applicationDomain.parentDomain){
					applicationDomain=applicationDomain.parentDomain;
				}else{
					break;
				}
			}
				
			try{
				result=applicationDomain.getDefinition(name) as Class;
			}catch(e:ReferenceError){
			}
			return result;
		}
		
		/**
		 * get a class by name in a specify movie clip.
		 * 从指定的MovieClip中取得一个Class。
		 *
		 * @param	name :String
		 * @param	mc : MovieClip
		 * @return Class
		 */
		public static function getClassByMovieClip(name:String,mc:MovieClip):Class{
			return getClass(name,mc.loaderInfo.applicationDomain);
		}
		
		/**
		 * create a class instance with a array as the constructor arguments.
		 * 通过一个Class和一个参数数组来构造一个实例。
		 *
		 * @param	clazz : Class
		 * @param	p : Array default null
		 * @return *
		 */
		public static function createInstance(clazz:Class,p:Array=null):*{
			if(clazz==null){
				return null;
			}
			p=p==null?[]:p;
			switch(p.length){
				case 0:
				return new clazz();
				break;
				case 1:
				return new clazz(p[0]);
				break;
				case 2:
				return new clazz(p[0],p[1]);
				break;
				case 3:
				return new clazz(p[0],p[1],p[2]);
				break;
				case 4:
				return new clazz(p[0],p[1],p[2],p[3]);
				break;
				case 5:
				return new clazz(p[0],p[1],p[2],p[3],p[4]);
				break;
				case 6:
				return new clazz(p[0],p[1],p[2],p[3],p[4],p[5]);
				break;
				case 7:
				return new clazz(p[0],p[1],p[2],p[3],p[4],p[5],p[6]);
				break;
				case 8:
				return new clazz(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7]);
				break;
				case 9:
				return new clazz(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8]);
				break;
				case 10:
				return new clazz(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9]);
				break;
			}
			return null;
		}
		/**
		 * create a factory class instance or static class instance by a object or a class with a method name and arguments.
		 * 根据一个对象（可能是Class）和一个参数数组来构造一个工厂实例。
		 *
		 * @param	factory	 factory object to create the instance.
		 * @param	method 	factory method. 
		 * @param	args 	factory method arguments. Default null.
		 * @return *
		 */
		public static function createFactoryInstance(factory:*,method:String,args:Array=null):*{
			if(factory==null){
				return null;
			}
			var fun:*=factory[method];
			if(fun is Function){
				return fun.apply(factory,args);
			}
			return fun;
		}
		
		
		
		
	}
}