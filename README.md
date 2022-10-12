# 32bit-ALU

https://github.com/Robin-WZQ/BIT-AI-Review

verilog语言，32位ALU加法器，支持加法并行方式和串行方式，6种运算（算术运算和逻辑运算），能够输出结果和4个标志位

## 实验内容

基于全加器，设计一个32位ALU，至少支持加法并行方式和串行方式，至少6种运算（算术运算和逻辑运算），能够输出结果和至少4个标志位。完成仿真验证和串并行进位链时间比较。

## 实验约束

实验设计加法相关采用结构化的描述方式，从全加器开始搭建或者按照逻辑运算，从基本门开始搭建，不直接使用Verilog HDL语言中的加法符号。其他ALU支持的运算自行确定设计方式。

## 功能描述

这里我设计了一个具有8种运算功能的32位ALU，实现6种逻辑运算和3种算术运算，并能够产生运算结果和其表示，ALU通过4根控制线ALU_OP[3:0]来选择其8种功能。

### 逻辑运算
![image](https://user-images.githubusercontent.com/60317828/147259387-6572f061-d6b4-4e02-8a36-4cff7b0e4b66.png)

### 算术运算

![image](https://user-images.githubusercontent.com/60317828/147259419-34c3b6b2-5361-4abb-9f51-fd910c295353.png)

### 标志位

![image](https://user-images.githubusercontent.com/60317828/147259443-ab7f72cf-aa10-4d78-a077-02c93b0e6105.png)

## ‘task’方法
在实验过程中，我发现在 always 语句下的条件分支结构不允许调用module 实例，所以为了尽可能提高 ALU 的处理速度，我对较为复杂的实例用任务进行改写，即主要应用了“task”方法。这里也简单叙述一下其特点：

任务（task）可以用来描述共同的代码段，并在模块内任意位置被调用，让代码更加的直观易读。任务可以调用函数和任务，可以作为一条单独的语句出现语句块中。需要强调的是，任务在执行的时候是按语句顺序执行的，所以需要在编写相关功能时考虑到。

## 实验结果

### 逻辑运算

![image](https://user-images.githubusercontent.com/60317828/149645018-d4b1d41c-a4eb-4212-9de9-e7b31c9bb10b.png)

### 并行运算

![image](https://user-images.githubusercontent.com/60317828/149645024-3cf86b18-885e-45fd-aca1-9ae079569267.png)

### 串行运算

![image](https://user-images.githubusercontent.com/60317828/149645032-c4f35adb-b8b2-4ab4-86ca-e158791f652f.png)
