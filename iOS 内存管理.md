# 内存管理





### CADisplayLink、NSTimer使用注意

CADisplayLink、NSTimer会对**target**产生强引用，如果target又对它们产生强引用，那么就会引发**循环引用**



即使传进去是weak类型的指针，也没有办法解决循环引用的问题

