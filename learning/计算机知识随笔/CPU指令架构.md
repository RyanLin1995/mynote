### 计算机五大单元
![捕获.PNG](0)
***
### CPU架构
精简指令集（Reduced Instruction Set Computer, RISC）：ARM

复杂指令集（Complex Instruction Set Computer, CISC）：AMD、Intel

32位个人计算机：x86架构，一次能读入32bits数据，即4GB左右
64位个人计算机：x86_64架构，一次能读入64bits数据，即8GB左右
***
## 内存控制单元
新版CPU已经把内存控制单元（北桥）直接整合到CPU，而CPU各项数据来源于主记忆体（RAM），如果RAM越大，效能越快。RAM传输速度取决于`前端总线速度（Front Side Bus，FSB）`。
RAM有其工作频率，即RAM上的频率（2666MHz，3200MHz）。一般来说，每次频率传输的数据量，大多为64位，即总线宽度为`64位宽度`
假设CPU内的内存控制芯片对主记忆体的工作频率最高达到1600Mhz，则：
```1600Mhz * 64bit = 1600Mhz * 8 Bytes = 12.8Gbyte/s```

