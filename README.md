# PHP nativ extention for parsing DocComment

## Dependency

- bison
- flex
- php-dev

```shell
apt install -y bison  
apt install -y flex  
apt install -y php-dev  
```
## How to build ?

### Build parse
```shell
cd src  
make all  
cd ..  
```
### Build php-extension

```shell
phpize  
./configure  

make  
sudo make install  
```
add to php.ini extension=doc.so  

## Check
```shell
php -m | grep DocComment  
```

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
* @Namespace::propery4([Option=True])
* @Namespace::propery4([Option=False])
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
  array(4) {
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
    ["PROPERY4"]=>
    array(2) {
      [0]=>
      array(1) {
        ["OPTION"]=>
        bool(true)
      }
      [1]=>
      array(1) {
        ["OPTION"]=>
        bool(false)
      }
    }
  }
}
```
