as-spring: ActionScript IOC framework
=====================================

as-spring is an ActionScript IOC framework, used to define and use dynamic objects without re-compile the source code.

Example
--------------

```xml
<?xml version="1.0" encoding="utf-8"?>
<spring-config>
	<beans>
		<bean id="textFieldBean" class="flash.text.TextField">

			<property name="text" value="Hello World"/>
			<property name="width" value="300"/>
			<property name="x" value="160"/>
			<property name="y" value="100"/>

			<method name="setTextFormat">
				<method-arg>
					<bean class="flash.text.TextFormat">
						<property name="color" value="0x003366"/>
						<property name="bold" value="true"/>
						<property name="size" value="36"/>
					</bean>
				</method-arg>
			</method>

		</bean>
	</beans>
</spring-config>
```

```as
import com.colorhook.spring.context.ContextLoader;

var contextLoader:ContextLoader = new ContextLoader();
contextLoader.addEventListener(Event.COMPLETE, onContextLoaderComplete);
contextLoader.load("as-spring.xml");

function onContextLoaderComplete(e){
	contextLoader.removeEventListener(Event.COMPLETE, onContextLoaderComplete);
	var bean:* = contextLoader.contextInfo.getBean("textFieldBean");
}
```

element bean
--------------
element bean是最简单也是最基础的bean，它代表最基本的数据结构

```xml
...
<element id='num' value='200' type='int'/>
<element id='num2' value='200' type='uint'/>
<element id='num3' value='200' type='Number'/>
<element id='str'>string type data</element>
<element id='arr'>[1,2,3,4]</element>
<element id='bool'>true</element>
...
```

list bean
--------------
list bean是一个数组对象，用于存放数组结构的数据

```xml
...
<list id='myList'>
  <element value='1' type='int'/>
  <element value='2'/>
  <element value='false' type='Boolean'/>
  <list>
  	<element value='4'/>
  	<element value='5'/>
  </list>
</list>
...
```

```as
var list:Array = contextInfo.getBean('myList') as Array;
trace(list); // [1, '2', false, ['4', '5']]
```

map bean
--------------
map bean是一个Hash对象，用于存放键值对结构的数据

```xml
...
<map id='myMap'>
  <key name='name' value='as-spring'>
  <key name='version'>2.x</key>
  <key name='info'>
  	<map>
  		<key name='contributors'>...</key>
  		<key name='github'>http://github.com/colorhook/as-spring</key>
  	</map>
  </key>
</map>
...
```

```as
var map:* = contextInfo.getBean('myMap');
trace(map); // {name: 'as-spring', version: '2.x', 
						//		info: {contributors: '...', github:'http://github.com/colorhook/as-spring'}}
```

singleton bean
--------------
bean可以是singleton类型的，即一个bean只会有单一实例

```xml
...
<bean id='sprite' type='flash.display.Sprite' singleton='true'>
</bean>
...
```

```as
var s1:Sprite = contextInfo.getBean('sprite') as Sprite;
var s2:Sprite = contextInfo.getBean('sprite') as Sprite;
trace(s1 === s2); //true
```

factory bean
--------------
factory bean表示一个bean不是通过new关键字创建的，而是通过工厂方法创建的

```as
package{
	public class Factory{

		public static function getObject():*{
			return xxx;
		}
	}
}
```

```xml
...
<bean id='obj' class='Factory' factory-method='getObject'>
</bean>
...
```

```as
var obj:* = contextInfo.getBean('obj');
```

通过swf文件反射bean
--------------
可以在一个SWF文件中输出class，然后在另一个SWF中通过bean的方式加载使用这个class

```xml
...
<classes>
	<class name='app.MyClass' lib='app.MyClass.swf'/>
</classes>
<beans>
	<bean id='app' class='app.MyClass'/>
</beans>
...
```

```as
var app:* = contextInfo.getBean('app');
```


API Reference
--------------
[http://colorhook.github.com/as-spring/]

Licence
--------------
as-spring is free to use under MIT license. 

	Copyright (c) 2010-2011 as-spring Authors. All rights reserved.

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.

Bugs & Feedback
----------------

Please feel free to report bugs or feature requests.
You can send me private message on `github`, or send me an email to: [colorhook@gmail.com]



