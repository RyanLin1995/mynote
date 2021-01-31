## 什么是Shell Scrip
shell script 是利用 shell 的功能所写的一个程序(program)，这个程序是使用纯文本文件，将一些 shell 的语法与指令(含外部指令)写在里面，搭配正规表示法、管线命令与数据流重导向等功能，以达到我们所想要的处理目的。

---
## Shell Scrip 注意事项
### Shell Scrip的编写
1. 指令的执行是从上而下、从左而右的分析与执行；
2. 指令的下达就如同第四章内提到的：指令、选项与参数间的多个空白都会被忽略掉；
3. 空白行也将被忽略掉，并且 tab 按键所推开的空白同样视为空格键；
4. 如果读取到一个 Enter 符号 (CR) ，就尝试开始执行该行 (或该串) 命令；
5. 至于如果一行的内容太多，则可以使用 \Enter 来延伸至下一行；
6.  \# 可做为批注！任何加在 # 后面的资料将全部被视为批注文字而被忽略！

PS：
1. 脚本在执行前需要确保拥有执行权限

---
## Shell Scrip格式
![vim.png](https://i.loli.net/2021/01/29/vrP69Itqifl7YUs.png)

### 说明：
**1. 第一行 #!/bin/bash 在声明这个 script 使用的 shell 名称：**
因为使用的是 bash ，所以必须要以 #!/bin/bash 来声明这个文件内的语法使用 bash 的语法，那么当这个程序被执行时，就能够加载 bash 的相关环境配置文件 (一般来说就是 non-login shell 的~/.bashrc)， 并且执行 bash 来执行底下的命令

**2. 程序内容的说明：**
整个 script 当中，除了第一行的 #! 是用来宣告 shell 的之外，其他的 # 都是批注用途。一般来说，建议写上以下内容：
  * 内容与功能； 
  * 版本信息； 
  * 作者与联络方式； 
  * 建檔日期；
  * 历史纪录；

**3. 主要环境变量的宣告：**
建议务必要将一些重要的环境变量设定好，如
 PATH 与 LANG。这可让程序在执行时，直接下达一些外部指令，而不必写绝对路径

**4. 主要程序部分**
即主要的程序语句。在这个例子当中，就是 echo 那一行

**5. 执行成果告知 (定义回传值)**
以利用 exit 这个指令来让程序中断，并且回传一个数值给系统。在这个例子是 exit 0 ，这代表离开 script 并且回传一个 0 给系统

---
## Scrip 执行与执行区别

### Shell Scrip的执行
* 直接指令下达： shell.sh 文件必须要具备可读与可执行 (rx) 的权限，然后：
  * 绝对路径：使用 /home/用户名/shell.sh 来下达指令；
  * 相对路径：假设工作目录在 /home/用户名/，则使用 ./shell.sh 来执行
  * 变量 PATH 功能：将 shell.sh 放在 PATH 指定的目录内，例如： ~/bin/
* 以 bash 程序来执行：透过 bash shell.sh 或 sh shell.sh 来执行

### Shell Scrip的执行区别
不同的 script 执行方式会造成不一样的结果：

#### 1、利用直接执行的方式来执行 script
即直接运行脚本或使用 bash 或 sh 或 ./ 执行脚本，该 script 都会使用一个新的 bash 环境(子程序)来执行脚本内的代码

示意图：

![](https://linux.vbird.org/linux_basic/centos7/0340bashshell-scripts/centos7_non-source.gif)

#### 2、利用 source 来执行脚本
即使用 source 命令执行 script，该 scrip 是在父程序中执行

示意图：

![](https://linux.vbird.org/linux_basic/centos7/0340bashshell-scripts/centos7_source.gif)

---
## 一些简单的案例
### 1、交互式脚本
交互式脚本，其变量内容由用户决定
![read.png](https://i.loli.net/2021/01/30/1XcgJWmaERSuCfj.png)

### 2、呼叫外部命令脚本
通过呼叫 date 进行文件的建立
![date.png](https://i.loli.net/2021/01/30/KR4eSq5bTxl3AuU.png)

### 3、计算式脚本
* **整数计算**
脚本中可以使用 declare -i total=${firstnu}*${secnu} 或 var=$((运算内容)) 进行整数的计算(+, -, *, /, %)，其中 % 为取余
![cal.png](https://i.loli.net/2021/01/30/1IVsc3JhPvBry4G.png)

* **小数运算**
计算圆周率，一般可用这个脚本测试服务器性能
![pi.png](https://i.loli.net/2021/01/30/VY26yAls8Ivp74U.png)

  * 代码：
`#!/bin/bash`
`# Program:`
`#       User input a scale number to calculate pi number.`
` # History:`
` # 2020/01/30    Ryan    First release`
` PATH=${PATH}:~/bin`
` export PATH`
` echo -e "This program will calculate pi value. \n"`
` echo -e "You should input a float number to calculate pi value.\n"`
` read -p "The scale number (10~10000) ? " checking`
` num=${checking:-"10"} # 开始判断有否有输入数值`
` echo -e "Starting calcuate pi value. Be patient."`
` time echo "scale=${num}; 4*a(1)" | bc -lq`

---
## Scrip 的判断式
### 测试命令：test
当要检测系统上面某些文件或者是相关的属性时，利用 test 。执行结果并不会显示任何讯息，但最后我们可以透过 $? 或 && 及 || 来展现整个结果
用法：`test [参数] 文件名`
