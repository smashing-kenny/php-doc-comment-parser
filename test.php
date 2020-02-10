<?php


/** 
* A test class
*
* @DI::inject(TyPeSJksJksj=Singelton, Test=Singelton)
* @DI::next(balb=tttt)
* @return baz
*/
class TestClass { 
	
}


//var_dump(get_class_methods('\Trackpoint\DependencyInjector\DocComment'));

//var_dump(DocComment);
$reflection = new ReflectionClass('TestClass');
var_dump($reflection->getDocComment());
var_dump(Trackpoint\DocComment::parse($reflection->getDocComment()));