# KVC

**通过KVC修改属性会触发KVO么 ?**

- 会

**KVC的赋值和取值过程是怎样的？原理是什么 ?**



### setValue:forKey:  的底层原理

> X表示属性名

- 按照顺序寻找**set**方法 （**setX:**、**_setX:**）

如果没有找到方法

- 查看 **accessInstanceVariablesDirectly** 的返回值（默认是 YES）
  - YES：按顺序查找成员变量 ( **`_X`、`_isX`、`X`、`isX`** )
    - 如果找到了成员变量，就**直接赋值**
    - 如果找不到成员变量，调用 **setValue:forUndefinedKey:** 并抛出异常
  - NO：不查找成员变量，直接调用 **setValue:forUndefinedKey:** 并抛出异常（**不允许直接赋值**）



### ValueForKey:  的底层原理

> X表示属性名

- 按照顺序寻找**get**方法 （ **getX、X、isX、_X** ）

如果没有找到方法

- 查看 **accessInstanceVariablesDirectly** 的返回值（默认是 YES）
  - YES：按顺序查找成员变量 ( **`_X`、`_isX`、`X`、`isX`** )
    - 如果找到了成员变量，就**直接取值**
    - 如果找不到成员变量，调用 **setValue:forUndefinedKey:** 并抛出异常
  - NO：不查找成员变量，直接调用 **setValue:forUndefinedKey:** 并抛出异常（**不允许直接取值**）