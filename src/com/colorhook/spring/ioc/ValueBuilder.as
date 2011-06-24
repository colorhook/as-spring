package com.colorhook.spring.ioc{


	import com.colorhook.spring.ioc.PrimitiveType;
	
	/**
	 *
	 * @author	colorhook
	 * @copyright http://www.colorhook.com
	 *
	 * ValueBuilder class used to return a reasonable value by parsing the type.
	 * ValueBuilder类会根据参数的类型来返回一个合理的值。
	 *
	 */

	public class ValueBuilder{
		
		/**
		 * return a reasonable value by a special type.
		 * 根据type来返回一个合理的值。
		 * @param	value
		 * @param	type
		 * @return *
		 */
		public static function getValue(value:String,type:String=null):*{
			var result:*;
			if(type==null||type==""){
				if(mayBeArray(value)){
					return convertToArray(value);
				}
				if(value=="true"){
					return true;
				}else if(value=="false"){
					return false;
				}
			}
			
			switch(type){
				case PrimitiveType.UINT:result=uint(value);break;
				case PrimitiveType.INT:result=int(value);break;
				case PrimitiveType.NUMBER:result=Number(value);break;
				case PrimitiveType.STRING:result=String(value);break;
				case PrimitiveType.ARRAY:result=convertToArray(value);break;
				case PrimitiveType.DATE:result=convertToDate(value);break;
				case PrimitiveType.BOOLEAN:result=convertToBoolean(value);break;
				default:result=value;break;
			}
			return result;
		}
		
		
		private static function mayBeArray(str:String):Boolean{
			if(str&&str.length>1&&str.charAt(0)=="["&&str.charAt(str.length-1)=="]"){
				return true;
			}
			return false;
		}
		
		private static function convertToBoolean(v:String):Boolean{
			return v=="true"||v=="1";
		}
		
		private static function convertToArray(v:String):Array{
			if(!mayBeArray(v)){
				return new Array();
			}
			var str:String=v.slice(1,v.length-1);
			var result:Array=str.split(",") as Array;
			for(var i:int=0;i<result.length;i++){
				var item:String=result[i] as String;
				if(item&&item.length>1){
					var case1:Boolean=item.charAt(0)=='"'&&item.charAt(item.length-1)=='"';
					var case2:Boolean=item.charAt(0)=="'"&&item.charAt(item.length-1)=="'";
					if(case1||case2){
						result[i]=item.slice(1,item.length-2);
					}
				}
			}
			return result;
		}
		
		private static function convertToDate(v:String):Date{
			var n:Number=Number(v);
			if(isNaN(n)){
				return new Date;
			}
			return new Date(n);
		}
		
	}
}