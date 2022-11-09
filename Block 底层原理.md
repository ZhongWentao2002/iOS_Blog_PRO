# Block

[TOC]



### 面试题





# Block 的本质

- block本质上也是一个**OC对象**，它内部也有个**isa指针**
- block是**封装了函数调用以及函数调用环境**的OC对象

![image](Images/Snipaste_2022-11-06_21-57-36.png)



![image](Images/Snipaste_2022-11-06_16-55-47.png)



和OC对象底层一样，Block的底层也是一个结构体

![image](Images/Snipaste_2022-11-06_16-43-45.png)



结构体内部

![image](Images/Snipaste_2022-11-06_16-49-48.png)

所以block就是指向这个结构体的指针，和OC对象一致



### __block_impl

![image](Images/__block_impl.png)

  





### 参数分析

- 第一个参数 void *fp ：传入的是 **__main_block_func_0**

这个就是block封装的代码

![image](Images/Snipaste_2022-11-06_16-56-26.png)

传进来的 **fp函数指针** 又赋值给了结构体内部的 **impl.FuncPtr**



- 第二个参数 是一个结构体指针 **__main_block_desc_0 *desc**

![image](Images/Snipaste_2022-11-06_18-22-43.png)

作用是对于一个block的描述信息，size就是block结构体的大小





# Block 的变量捕获 ( capture )

![image](Images/Snipaste_2022-11-06_20-10-41.png)

### auto 变量（局部变量）

![image](Images/Snipaste_2022-11-06_19-28-20.png)

block在访问外界局部变量时，会新增加一个成员变量

![image](Images/Snipaste_2022-11-06_19-55-03.png)

相当于把 age 这个值 捕获进来了

因为局部变量随时可能销毁，所以使用值传递的方法



### static 变量（静态局部变量）

![image](Images/Snipaste_2022-11-06_20-27-10.png)

height 的值会随着外界而改变



![image](Images/Snipaste_2022-11-06_20-30-56.png)

静态局部变量是指针的形式

静态局部变量的生命周期会持续到程序结束，所以可以随时通过指针取访问那块分配好的内存



### 全局变量

全局变量的效果与静态局部变量差不多，都会随外界变化，但是底层的实现不同

block在访问全局变量时，不会捕获到block内部，采取直接访问的方式（不需要捕获，也不需要指针）



### 一道题

![image](Images/Snipaste_2022-11-06_21-28-02.png)

问：这里的 self 是怎么访问的

![image](Images/Snipaste_2022-11-06_21-30-41.png)

为什么会被捕获？

- 能被捕获说明 self是一个局部变量

为什么 self 是一个局部变量？

- OC方法内部默认有两个参数 一个是调用者（self），另一个是 SEL _cmd （方法名）

![image](Images/Snipaste_2022-11-06_21-37-32.png)

- 函数的参数就是局部变量



# Block 的类型

既然之前说过，Block是OC对象，那么我们就可以通过调用 class 方法来看Block的类型

![image](Images/Snipaste_2022-11-06_22-36-17.png)

![image](Images/Snipaste_2022-11-06_22-40-24.png)

![image](Images/Snipaste_2022-11-07_02-05-44.png)

`__NSStackBlock__` 调用copy后，就升级成一个 `__NSMallocBlock__`

所以在开发过程中，我们都要对block进行copy操作，如果block作为属性，用copy修饰，确保block不被销毁



### Block 的 copy

![image](Images/Snipaste_2022-11-07_05-03-08.png)

# Block 访问 auto 对象

⚠️当bloc访问**OC对象**的时候（基本数据类型指针不行，必须是**id类型**，并且这个id可以为null，总之只要访问id），block内部的 desc 会发生变化，多两个函数

![image](Images/copy-dispose.png)

![image](Images/Snipaste_2022-11-07_16-48-42.png)



不管是ARC还是MRC，**栈空间的block不会持有外面对象**

栈空间的block本身随时都会被销毁，没必要强引用其他对象

⚠️与访问的对象是强指针还是弱指针**无关**



**堆空间的block会自动持有外界对象**

ARC不释放是因为**ARC自动调用了copy**，使得栈block变成了堆block



### 如果block被拷贝到堆上（变成堆block）

- 自动会调用**block内部的copy**函数

- copy函数内部会调用 **_Block_object_assign** 函数

- **_Block_object_assign** 函数会根据auto变量的修饰符（__strong、__**weak**、**__unsafe_unretained** ）做出**相应的操作**，形成强引用（retain）或者弱引用





![image](Images/Snipaste_2022-11-07_05-21-37.png)

是因为block对象内部有一个强类型的指针指向外界这个对象，只有当block销毁时，MJPerson会释放



![image](Images/Snipaste_2022-11-07_06-29-17.png)



由于这里是 weak 弱引用，所以person离开作用域就销毁了



![image](Images/Snipaste_2022-11-07_06-43-25.png)





**MRC的情况**



![image](Images/Snipaste_2022-11-07_06-09-43.png)



![image](Images/Snipaste_2022-11-07_06-13-33.png)



### 如果block从堆上移除

- 会调用block内部的dispose函数

- dispose函数内部会调用_Block_object_dispose函数

- _Block_object_dispose函数会自动释放引用的auto变量（release）



# __block 修饰符

默认情况下，block 内部不允许**修改**外界的局部auto变量

注意修改和使用的区别

对于对象来说，调用对象的方法**不属于修改**

修改对象的属性也**不属于修改**

只要不给对象（这个指针）赋值新值，就不算修改

![image](Images/Snipaste_2022-11-08_04-28-32.png)

#### 方法一 改为 static

![image](Images/Snipaste_2022-11-08_04-33-48.png)

因为static变量是通过 **指针** 捕获



#### 方法二 使用 __block 修饰

![image](Images/Snipaste_2022-11-09_11-22-15.png)



### __block 的本质

- __block可以用于解决block内部无法修改auto变量值的问题

- __block**不能修饰全局变量、静态变量**（static）

- 编译器会将__block变量**包装成一个对象**

![image](Images/__block.png)

![image](Images/__block_2.png)



**__block int age = 10 的本质**

![image](Images/Snipaste_2022-11-08_20-43-22.png)



### __block 的内存管理

- 当block在**栈**上时，并不会对__block变量产生强引用

- 当block被copy到**堆**时
  - 会调用block内部的**copy**函数
  - **copy**函数内部会调用**_Block_object_assign**函数
  - **_Block_object_assign**函数会对**__block变量**形成强引用（retain）



- 当block从堆中移除时 
- 会调用block内部的**dispose**函数
- **dispose**函数内部会调用**_Block_object_dispose**函数
- **_Block_object_dispose**函数会自动释放引用的**__block变量**（release）



⚠️ 这里和**栈block访问auto对象，变为栈block的过程很类似**，接下来做出一个区分



