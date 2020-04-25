# PHP nativ extention for parsing DocComment

## Dependency

- bison
- flex
- php-dev

apt install -y bison
apt install -y flex
apt install -y php-dev

## How to build ?

### Build parse

cd src
make all
cd ..

### Build php-extension

phpize 
./configure

make
sudo make install

add to php.ini extension=doc.so

## Test
php -m | grep DocComment


## Example

### Simple usage example
```php
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
```

### Output
```
array(1) {
  ["NAMESPACE"]=>
  array(3) {
    ["PROPERY1"]=>
    array(2) {
      ["OPTION1"]=>
      string(5) "Value"
      ["OPTION2"]=>
      string(5) "Value"
    }
    ["PROPERY2"]=>
    array(1) {
      ["OPTION"]=>
      string(5) "Value"
    }
    ["PROPERY3"]=>
    array(0) {
    }
  }
}
```
