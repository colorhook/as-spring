as-spring: ActionScript IOC framework
=====================================

as-spring is an ActionScript IOC framework, used to define and use dynamic objects without re-compile the source code.

Example
--------------
	import com.colorhook.spring.context.ContextLoader;

	var contextLoader:ContextLoader = new ContextLoader();
	contextLoader.addEventListener(Event.COMPLETE, onContextLoaderComplete);
	contextLoader.load("as-spring.xml");

	function onContextLoaderComplete(e){
		contextLoader.removeEventListener(Event.COMPLETE, onContextLoaderComplete);
		var bean:* = contextLoader.contextInfo.getBean("myBean");
	}

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



