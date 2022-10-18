# OC对象的分类

- **instance **  (**实例**对象)

- **class**   (**类**对象)
- **meta-class**   (**元类**对象)



### instance 实例对象

![image](Images/Snipaste_2022-10-17_16-50-58.png)

- 实例对象内部存储成员变量的值



### Class 类对象

![image](Images/Snipaste_2022-10-17_16-56-16.png)

```objective-c
typedef struct objc_class *Class
```

- Class 的本质是指向一个 **objc_class** 结构体的指针

- 一个类的类对象是唯一的，在内存中只有一份

- 注意存储的是 **成员变量信息** （类型，名字） 不是成员变量的具体值



### meta-class 元类对象

> meta-data 元数据，用来描述数据的数据
>
> meta-class 元类，用来描述类的类

- 元类对象也是 **Class** 类型

![image](Images/Snipaste_2022-10-18_16-13-17.png)

- 注意元类对象只能通过 Runtime去获取，[NSObject class] class]] 只能获取类对象（无论调用多少次class方法）

- objc_getClass 内部是根据名字找 **类对象**，无法访问元类对象
- object_getClass 内部是访问 **isa指针**