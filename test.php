<?php

use Trackpoint\DocComment;

/** 
* A test class
*
* @Namespace::propery1(Option1=Value, Option2=Value)
* @Namespace::propery2(Option=Value)
* @Namespace::propery3()
* @return baz
*/
class TestClass { 
	
}


$reflection = new ReflectionClass('TestClass');
var_dump(DocComment::parse($reflection->getDocComment()));