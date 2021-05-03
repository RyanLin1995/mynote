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
当要检测系统上面某些文件或者是相关的属性时，可以使用 test 。其执行结果并不会显示任何讯息，但可以透过 $? 或 && 及 || 来展示
用法：`test [参数] 文件名`

**1.关于某个文件名的文件类型判断，例如 test -e filename**
|测试的标志|代表意义|
|-|-|
|-e|该文件名是否存在(常用)|
|-f|该文件名是否存在且为文件(file)(常用)|
|-d|该文件名是否存在且为目录(directory)(常用)|
|-b|该文件名是否存在且为一个 block device 装置|
|-c|该文件名是否存在且为一个 character device 装置|
|-S|该文件名是否存在且为一个 Socket 文件|
|-p|该文件名是否存在且为一个 FIFO(pipe) 文件|
|-L|该文件名是否存在且为一个链接文件|

**2. 关于文件的权限检测( root 权限有例外)，例如 test -r filename**
|测试的标志|代表意义|
|-|-|
|-r|检测该文件名是否存在且具有可读(read)的权限|
|-w|检测该文件名是否存在且具有可写(write)的权限|
|-x|检测该文件名是否存在且具有可执行(execute)的权限|
|-u|检测该文件名是否存在且具有 SUID 的属性|
|-g|检测该文件名是否存在且具有 SGID 的属性|
|-k|检测该文件名是否存在且具有 Sticky bit 的属性|
|-s|检测该文件名是否存在且为非空白文件|

PS:
1. 由于 root 在很多权限的限制上面都是无效的，所以使用 root 进行权限判断时，常常会发现与 ls -l 的结果并不相同

**3. 两个文件之间的比较，例如：test file1 -nt file2**
|测试的标志|代表意义|
|-|-|
|-nt|newer than，判断 file1 是否比 file2 新|
|-ot|older than，判断 file1 是否比 file2 旧|
|-ef|判断 file1 与 file2 是否为同一文件，可用于判断 hard link ，即看两个文件是否均指向同一个 inode |

**4. 两个整数之间的比较，例如 test n1 -eq n2**
|测试的标志|代表意义|
|-|-|
|-eq|两数值相等(equal)|
|-ne|两数值不等(not equal)|
|-gt|n1 大于 n2 (greater than)|
|-lt|n1 小于 n2 (less than)|
|-ge|n1 大于等于 n2 (greater than or equal)|
|-le|n1 小于等于 n2 (less than or equal)|

**5. 判定字符串的数据，例如 test -z string**
|测试的标志|代表意义|
|-|-|
|-z string|判定字符串长度是否为 0 ，若 string 为空字符串，则为 true|
|-n string|-n 可省略。判定字符串长度是否非为 0 ，若 string 为空字符串，则为 false|
|str1 == str2|判定 str1 是否等于 str2 ，若相等，则为 true|
|str1 != str2|判定 str1 是否不等于 str2 ，若相等，则为 false|

**6. 多重条件判定，例如： test -r filename -a -x filename**
|测试的标志|代表意义|
|-|-|
|-a|(and)两状况同时成立。如 test -r file -a -x file，则 file 同时具有 r 与 x 权限时，才为 true|
|-o|(or)两状况任何一个成立。如 test -r file -o -x file，则 file 具有 r 或 x 权限时，才为 true|
|!|反相状态，如 test ! -x file ，当 file 不具有 x 时，才为 true|

**一个例子：**

![test.png](https://i.loli.net/2021/01/31/DJwIl5aH2C9PirB.png)

### 简化测试命令：[]
简化的测试命令[]，其参数与 test 一直，但是必须要注意中括号的两端需要有空格符来分隔。[] 比较常用在条件判断式中
用法：`[ 参数 文件名 ]`

注意：
* 在中括号 [] 内的每个组件都需要有空格键来分隔
* 在中括号内的变量，最好都以双引号括号起来
* 在中括号内的常量，最好都以单或双引号括号起来

**一个例子：**

![test2.png](https://i.loli.net/2021/01/31/4BKYq1gjIhHxXF8.png)

### Shell Scrip的默认参数
Shell scrip除了可以使用 read 命令传入参数外，其实还有一些默认的参数。
如下图：
![scrip1.png](https://i.loli.net/2021/04/04/GfOkglH8ZoIB41C.png)

* 图中的 $0 代表 scrip 的名字
* 图中的 $1、$2、$3...代表的是第几个参数，默认第一个参数是 $1
* 一些特殊的默认参数： 
  * $# : 代表后接的参数个数
  * $@ : 代表"$1" "$2" "$3" "$4" 的意思，每个变量是独立的(用双引号括起来)
  * $* : 代表 "$1c$2c$3c$4" ，其中 c 为分隔字符，默认为空格键，如 "$1 $2 $3 $4" 

**一个例子：**
#### 代码：
![scrip2-code.png](https://i.loli.net/2021/04/04/lTviqweSyRMm4oI.png)
#### 结果：
![scrip2.png](https://i.loli.net/2021/04/04/vK3TIgzYM7boBG6.png)

### 参数号码偏移(shift):
偏移(shift)：指移动变量，代表去掉最前面的几个参数的意思。shift 后面可以接数字

**例如：**
##### 代码：
![scrip3-code.png](https://i.loli.net/2021/04/04/Xb4P7gcS3uVULq6.png)
##### 结果：
![scrip3.png](https://i.loli.net/2021/04/04/vaiMgp3XxQqfBre.png)

---
## 条件判断
### 1. if...then...
if .... then 是最常见的条件判断式。即当符合某个条判的时候，就进行某项工作。

#### 单层、简单条件判断：
**样式：**
![if.png](https://i.loli.net/2021/04/10/hp6eDOnmFQksVBS.png)

其中，有多个条件进行判断时，除了可以将多个判断写在一个 [] 内，如`[ a == "Y" -o a == "y" ]`；也可以将多个判断写在多个 [] 中，如 `[ a == "Y" ] || [a == "y" ]`，这里的 || 表示 or 的意思，如果要表示 and，则用 &&。

**一个例子：**
![if1.png](https://i.loli.net/2021/04/10/kc6XZ5dgzi37KEh.png)

#### 多层、复杂条件判断
**样式1：**
![if2.png](https://i.loli.net/2021/04/10/o7im5hvgYfGd1tA.png)
**样式2：**
![if3.png](https://i.loli.net/2021/04/10/bN5w9QGcK3T7CWs.png)

**一个例子：**
![if4.png](https://i.loli.net/2021/04/10/JlcBgoE9Tf84ZxA.png)

### 2. case...esac
如果需要既定变量执行某些代码，可以使用case....esac

**样式:**
![case1.png](https://i.loli.net/2021/05/01/cIq6NPXuobMgWTs.png)

**一个例子:**
![case2.png](https://i.loli.net/2021/05/01/h7VKyeo5mNaH9lM.png)

---
## 函数Function
将需要重复使用的代码封装在一起并给予一个名字，这就是函数(Function)

**样式:**
![function.png](https://i.loli.net/2021/05/02/GAMEYcj1KaBr3Dy.png)

因为 shell script 的执行方式是由上而下，由左而右，因此在 shell script 当中的 function 的设定一
定要在程序的最前面

**一个例子:**
![function1.png](https://i.loli.net/2021/05/02/oWcXR9H81AdBqIx.png)

### Function 内建变量
function 也拥有内建变量，与 shell script 的类似， 函数名称为 $0 ，而后续接的变量也是以 $1, $2... 来取代。但是 function 的内建变量仅属于 function，与 shell script 的 $0，$1... 等无关

**代码说明**
![function3.png](https://i.loli.net/2021/05/02/efhq76w5GVxsbHp.png)

---
## 循环
### 1. 不定循环 while do done 与 until do done
#### while样式:
当条件成立时，就进行循环，直到条件不成立才停止
**样式:**
![while.png](https://i.loli.net/2021/05/02/4Ecp6MLoeG9UkWv.png)
**例子:**
![while1.png](https://i.loli.net/2021/05/02/GL9y7xXamUVNckw.png)

#### until样式:
当条件成立时，就终止循环， 否则就持续进行循环的程序段(与 while 相反)
**样式:**
![until.png](https://i.loli.net/2021/05/02/as2DwoEGWlemNQ9.png)
**例子:**
![until1.png](https://i.loli.net/2021/05/02/g3I8yF7oOezBKjs.png)

#### 案例
计算 1+2+3+....+100
![图像 9.png](https://i.loli.net/2021/05/02/lhu9OxWnkMp6IS2.png)

### 2. 固定循环 for...do...done
#### 一般固定循环
**样式:**
![for1.png](https://i.loli.net/2021/05/03/kZ3nrJ7MmP2sWTF.png)
