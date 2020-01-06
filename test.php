<?php

namespace Trackpoint\DependencyInjector;

use ReflectionClass;

//$source = "@DI::inject()";
//


/** 
* A test class
*
* @DI::inject(TyPeSJksJksj=Singelton)
* @return baz
*/
class TestClass { 
	
}

var_dump(DocComment::STATEMENT);
var_dump(DocComment::REGISTER);
var_dump(DocComment::OPTIONS);
var_dump(DocComment::INJECT);

var_dump(get_class_methods('\Trackpoint\DependencyInjector\DocComment'));

//var_dump(DocComment);
//$reflection = new ReflectionClass('\Trackpoint\DependencyInjector\TestClass');
//var_dump($reflection->getDocComment());
//var_dump(DocComment::parse($reflection->getDocComment()));