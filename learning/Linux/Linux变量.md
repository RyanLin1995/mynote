## 变量
变量就是以一组文字或符号等，来取代一些设定或者是一串保留的数据。

## Linux 变量
Linux 中的变量分为两种，一种是环境变量，一种是自定义变量。
一般情况下，在 Linux 预设的情况中，使用大写的字母来设定的变量一般为系统内定需要的变量(不论是环境变量与否)

## 变量的显示与设置
### 变量的显示: echo
echo 可以输出变量的值，具体用法为 `echo $'varname'`

### 变量赋值: =
可以使用 = 给变量赋值
例如赋予变量名 name 的值为 ryan : `name = ryan`
输出变量 name 的值为: `echo $name`

### 取消变量赋值: unset
可以直接使用 unset 来取消变量名的赋值，具体用法: `unset 'varname'`

## 变量设定规则
1. 变量通过 = 赋值，如: 变量 = 变量内容
2. 等号两边不能直接接空格
3. 变量名称只能是英文字母跟数字，但不能以数字开头
4. 变量内容若有空格符可以使用双引号 "" 或单引号 '' 将变量内容结合起来
5. 可用转义字符 \ 将特殊符号(如 [Enter], $, \, 空格符, '等)变成一般字符
6. 在命令中需要用到其他命令，可以使用反单引号 \`命令\` 或 $(指令)
7. 需要为变量扩增变量内容时，可用 变量名="$变量名称"添加内容 或 变量名=${变量}添加内容 进行累加
8. 若变量需要在其他子程序执行，则需要以 export 来使变量变成环境变量
9. 通常大写字符为系统默认变量，自行设定变量使用小写字符；
10. 取消变量的方法为使用 unset 

#### PS: 
常用的转义字符有如下:
|字符|说明|例子|
|-|-|-|
|反斜杠(\)|使反斜杠后面的一个变量变为单纯的字符串|`echo she\'s\ girl`|
|单引号('')|转义其中所有的变量为单纯的字符串|`echo PATH is '$PATH'`|
|双引号("")|保留其中的变量属性，不进行转义处理|`echo PATH is "$PATH"`|
|反引号(\`\`)|把其中的命令执行后返回结果|ll -d /lib/modules/\`uname -r\`|

## 环境变量的观察与说明
### 观察环境变量: env
用法: `env`

#### env 常用变量说明:
##### HOME:
用户的家目录。通过 cd ~ 或者 cd 直接回到用户家目录，就是取用这个变量。

##### SHELL:
说明用户目前使用的 SHELL 是哪个 shell，Linux 默认为 /bin/shell

##### HISTSIZE
历史指令，即用户曾输入的指令，存放地点为用户家目录下的 .bash_history。一般上限为 1000，可在 /etc/profile 中设置上限值。

当需要使用到某些历史指令时，可通过上下键进行查找，或者使用 `history` 找出指令号码，用 `!指令号码` 使用

##### MAIL
Linux 自带邮件系统的邮件保存路径

##### PATH:
当你需要使用一个`命令`时，系统会根据 PATH 的设定去查找PATH定义的目录下是否含有这个`命令`的可执行文件。如果含有多个同名的`命令`可执行文件，先搜寻到的将会被执行

变量PATH由一堆目录组成，目录之间用`:`隔开，每个目录有顺序之分,不同的身份使用者预设的PATH不同，默认能够随意执行的指令也不同

* 增加PATH: `PATH="${PATH}:/root"` (把/root添加到PATH)

##### LANG
语系，程序打开时会自动分析这个变量，看语系是否被支持，不支持的话有可能出现乱码

##### RANDOM
随机数生成器，范围为 0-32767 ，生成器文件保存在 /dev/random

随机生成 0-9 的数字: `declare -i number=$RANDOM*10/32768 ; echo $number`

### 查看所有变量(环境变量与自定义变量): set
用法: `set`

#### set 常用变量说明
##### PS1
PS1 为命令提示字符。PS1内显示一些特殊符号，这些特殊符号可以显示不同的信息，每个 distributions 的 bash 默认的 PS1 变量内容可能有些许的差异，这些符号与 bash 中的转义字符没有任何关系。Centos 默认 PS1
 为: `[\u@\h \W]\S`
|字符|含义|
|-|-|
|\d|可显示出 星期 月 日 的日期格式，如："Mon Feb 2"|
|\H|完整的主机名|
|\h|仅取主机名在第一个小数点之前的名字|
|\t|显示时间，为 24 小时格式的 HH:MM:SS|
|\T|显示时间，为 12 小时格式的 HH:MM:SS|
|\A|显示时间，为 24 小时格式的 HH:MM|
|\@|显示时间，为 12 小时格式的 am/pm 样式|
|\u|目前使用者的账号名称，如 root|
|\v|BASH 的版本信息，如主机版本为 4.2.46(1)-release，仅取4.2显示|
|\w|完整的工作目录名称，由根目录写起的目录名称。但家目录会以 ~ 取代|
|\W|利用 basename 函数取得工作目录名称，即仅会列出最后一个目录名|
|\#|下达的第几个指令|
|\$|提示字符，如果是 root 时，提示字符为 # ，否则就是 $|

##### 本 shell 的 PID: $
$ 表示 shell 自己的线程号(Process ID，PID)。查看 shell 自身线程号可以用 `echo $$`

##### 返回上一个指令执行的值: ?
? 表示上一个执行的命令的返回值。当执行指令时，指令都会回传一个执行后的代码。如果执行指令成功，则会回传一个0值，如果执行错误，就会回传非 0 的错误代码。

## 转变自定义变量为环境变量: export
* 单纯显示环境变量: `export`
* 将变量转为环境变量: `export 自定义变量名称`

## 影响变量输出的语系变量: locale
Linux 支持众多语系，如果在使用命令输出时出现了乱码的情况，说明系统语系出现了问题，此时可以通过 `locale` 查询
* 查询系统支持语系(即查看 usr/lib/locale 目录): `locale -a`
* 查看当前语系(即查看/etc/locale.conf): `locale`
PS:
1. 可以单独设置每项语系的数据，但是一般通过设置 LANG 或 LC_ALL 对全部语系进行设置
2. 需要临时改变语系，可以使用 `export LC_ALL="语系"` 或 `LANG="语系"` 进行设置。但是如果想永久改变语系，需要改动 /etc/locale.conf 目录

## 变量的键盘读取，数组与宣告
### 从键盘读取变量(命令交互模式): read
用法: `read [-pt] 变量名`

|选项与参数|解析|
|-|-|
|-p|接交互的提示字符|
|-t|接等待的秒数，即等待 -t 后的秒数后，用户不输入的话，自动略过|

* 例子:
1. 让用户输入任意内容并保存到 test 变量:
![图像 4.png](https://i.loli.net/2020/12/06/wVfAONtvUCFWIZe.png)
2.让用户输入名字并保存到 name 变量，等待10秒:
![图像 5.png](https://i.loli.net/2020/12/06/K2ku4pJUZVcHxGR.png)

### 宣告变量类型: declare/typeset
在 bash 中，默认所有的变量类型为字符串，因此如果不指定变量类型，当需要使用到算术时，bash 会认为所有算术都是字符串而不是计算式，因此需要宣告变量。(但是 bash 只支持整数计算)

用法: `declare [-aixr] 变量`
如果单纯是 `declare` 命令，则跟 `set` 命令一样，列出所有的变量

|选项与参数|解析|
|-|-|
|-a|宣告为数组(array)|
|-i|宣告为整数数字(integer)|
|-x|与 export 一样，把变量输出为环境变量|
|-r|将变量设置为 readonly 类型，不能被更改跟 unset|
|-p|列出变量类型|

* 例子:
1. 计算 sum=100+200+300 的结果:
![图像 7.png](https://i.loli.net/2020/12/06/smuCnf7xdr4OXYU.png)
2. 输出/取消 sum 为环境变量:
![图像 13.png](https://i.loli.net/2020/12/06/vTOU76VLh2Qctsb.png)
3. 列出变量类型:
![图像 14.png](https://i.loli.net/2020/12/06/5DkrvTZMsWm7FPB.png)

### 数组类型: array
* 数组类型一般用于写程序用，设定方式为: `变量名[index]=content`
* 但是输出时注意，一定要使用 `${变量名}` 输出，不然会出现问题
* 例子:
![图像 15.png](https://i.loli.net/2020/12/06/6zgt2TYUh7OBsIb.png)

## 变量的删除与替换
### 变量的删除
|设定方式|说明|
|-|-|
|${变量名#关键词}|从变量**左边**开始匹配符合关键词的，将符合关键词的最**短**数据删除|
|${变量名##关键词}|从变量**左边**开始匹配符合关键词的，将符合关键词的最**长**数据删除|
|${变量名%关键词}|从变量**右边**开始匹配符合关键词的，将符合关键词的最**短**数据删除|
|${变量名%%关键词}|从变量**右边**开始匹配符合关键词的，将符合关键词的最**长**数据删除|

例子:
1. 从**左边**开始进行最**短**匹配原则删除 path 变量中 bin: 结尾的数据:
![图像 1.png](https://i.loli.net/2020/12/12/mrzy9AgB57bpxKv.png)

2. 从**左边**开始进行最**长**匹配原则删除 path 变量中 bin: 结尾的数据:
![图像 2.png](https://i.loli.net/2020/12/12/dGyWqmj8wRVnxkO.png)

3. 从**右边**开始进行最**短**匹配原则删除 path 变量中 sbin: 结尾的数据:
![图像 3.png](https://i.loli.net/2020/12/12/MlwBgLSEtKfzoHY.png)

4. 从**右边**开始进行最**长**匹配原则删除 path 变量中 sbin: 结尾的数据:
![图像 4.png](https://i.loli.net/2020/12/12/cvyajqAGlSzIspC.png)

### 变量的测试与替换
命令格式: `var=${str[-+=?]content}`

|变量设定方式|str 没有赋值时|str 为空时|str 已赋予非空值时|
|-|-|-|-|
|var=${str-content}|var=content|var=|var=$str|
|var=${str:-content}|var=content|var=content|var=$str|
|var=${str+content}|var=|var=content|var=content|
|var=${str:+content}|var=|var=|var=content|
|var=${str=content}|str=content;var=content|str不变;var=content|str不变;var=$str|
|var=${str:=content}|str=content;var=content|str=content;var=content|str不变;var=$str|
|var=${str?content}|content输出stderr|var=|var=$str|
|var=${str:?content}|content输出stderr|content输出stderr|var=$str|

PS:
1. str: 代表 str 没设定或赋予了**空**字符串
2. str 代表 str 没有赋值

一些例子:
