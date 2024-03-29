# Linux 账号与群组
一般登录 Linux 的时候，输入的是字符串的账号，但是其实 Linux 主机并不会直接认识字符串组成的账号，它仅认识 ID 。由于计算机仅认识 0 与 1，所以主机对于数字比较有概念的；至于账号只是为了让人们容易记忆而已。而 ID 与账号的对应就在 `/etc/passwd` 文件中。

每个登入 Linux 的使用者至少都会取得两个 ID ，一个是使用者 ID (User ID ，简称UID)、一个是群组 ID (Group ID ，简称 GID)。文件通过 UID 与 GID 判别它的拥有者与群组，当需要显示文件属性的需求时，系统会依据 `/etc/passwd` 与 `/etc/group` 的内容， 找到 UID / GID 对应的账号与组名再显示出来。

## 使用者账号
Linux 系统上面的用户如果需要登入主机以取得 shell 的环境来工作时，要先利用 tty1~tty6 的终端机提供的 login 接口，输入账号与密码登入 (网络登录使用 ssh) 。那么你输入账号密码后，系统会进行一下操作:
1. 匹配 `/etc/passwd` 里面是否存在输入的账号。没有则跳出，有则将该账号对应的 UID 与 GID (在 `/etc/group` 中) 读出来，且读出该账号的家目录与 shell 设定；
2. 再来则是在 `/etc/shadow` 里面找出对应的账号与 UID，然后核对一下输入的密码与保存的密码是否一致；
3. 如果一切都 OK ，就进入 Shell 

---
### /etc/passwd 与 /etc/shadow
#### /etc/passwd 文件结构
`/etc/passwd`中的文件结构是每一行都代表一个账号，有几行就代表有几个账号在系统中。
文件以 : 号作为分隔，每一个 : 是一个字段。

![passwd.png](https://i.loli.net/2021/05/05/sdBtir6CHN41XAO.png)

##### 字段详细说明：
* **1.账号名称**：即账号，用来登入系统且需要对应 UID 
* **2.密码**：代表该账号设置了密码，密码保存在` /etc/shadow 中``
* **3.UID**：使用者标识符，通常 Linux 对于 UID 有以下限制

|id 范围|该 ID 使用者特性|
|-|-|
|0 (系统管理员)|当 UID 是 0 时，代表这个账号是系统管理员，如果要让其他的账号也具有 root 的权限时，将该账号的 UID 改为 0 即可(但不建议)。也就是说，一个系统上不是叫 root 的就是系统管理员，而是 UID 为 0 的才是|
|1~999(系统账号)|保留给系统使用的 ID，除了 0 之外，其他的 UID 权限与特性并没有差别。由于系统上面启动的网络服务或背景服务希望使用较小的权限去运作，不希望直接使用 root 的身份去执行这些服务，所以默认 1000 以下的数字让给系统作为保留账号。这些系统账号通常是不可登入的。根据系统账号的由来，通常这类账号又约略被区分为两种：1~200：由 distributions 自行建立的系统账号；201~999：若用户有系统账号需求时，可以使用的账号 UID。|
|1000~60000(可登入账号)|给一般使用者建立账号使用|
* **4.GID**：关联 `/etc/group` 。通常新建账号时，也会在 `/etc/group` 中新建一个与账号名一样的 Group，两者就是靠 GID 关联起来
* **5.用户信息栏**：这个字段基本上并没有什么重要用途，只是用来解释这个账号的意义
* **6.家目录**：用户的家目录，默认为 `/home/yourIDname`， root 的家目录在 /root 。如果某个账号的使用空间特别的大，可修改这个字段将用户登入家目录修改到别的地方。
* **7.Shell**：指定用户登入系统后取得 Shell 的类型。如果要禁止账号取得 shell 环境，就是 /sbin/nologin

#### /etc/shadow 文件结构
`/etc/shadow` 文件结构跟 `/etc/passwd` 文件结构类似。每一行对应一个账号

* 问：为什么要有 `/etc/shadow` 文件？
* 答：早期的密码放在 `/etc/passwd` 的第二个字段上，密码也有加密过。程序运行需要到
 `/etc/passwd` 读取账号的权限。因此 `/etc/passwd` 的权限需设定为 `-rw-r--r--`。
但是加密过的密码够透过暴力破解法破解出来。因为这样，后来发展出将密码移动到 /etc/shadow 这个文件分隔开来的技术， 而且只有 root 有权限访问 `/etc/shadow` 。

`/etc/shadow` 同样以 : 为分隔符，一个 : 是一个字段

![shadow.png](https://i.loli.net/2021/05/23/OWdtXuInCJbqizg.png)

##### 字段详细说明：
* **1. 账号名称：** 账号，必须要与 /etc/passwd 中的账号相同

* **2. 密码：** 账号真正的密码，经过编码(加密) 。密码的长度不能随意修改，因修改后长度不一致，可能导致密码就会失效(算不出来)。因此很多软件透过这个功能，在此字段前加上 ! 或 * 改变密码字段长度，让密码暂时失效

* **3. 最近更动密码的日期：** 记录了密码变更那一天的日期，数字 18658 为 Linux 系统从计算机开始时间(1970年1月1日)到密码变更的那一天的日期

* **4. 密码不可被更动的天数(与第 3 字段相比)：** 记录了这个账号最近一次被更改密码后需要经过几天才可以再变更密码。 0 表示密码随时可以变更的意思。设置了数字的话就指从改变密码那天起，多少天后才能再次变更密码。如设定为 20 天的话，则修改了密码之后 20 天后才能再次改密码

* **5. 密码需要重新变更的天数(与第 3 字段相比)：** 指定最近一次更改密码后，多少天数内需要再次变更密码，否则账号的密码将会变为过期特性。 99999 表示不需要变更密码

* **6. 密码需要变更期限前的警告天数(与第 5 字段相比)：** 当账号的密码有效期限快要到的时候(第 5 字段)，系统会依据这个字段的设定，发出警告信息，提醒用户修改密码

* **7. 密码过期后的账号宽限时间(密码失效日)(与第 5 字段相比)：** 在密码过期后，如果用户还是没有在宽限时间内登入更改密码，那么这个账号的密码将会失效，即该账号再也无法使用该密码登入了。要注意密码过期与密码失效并不相同。
密码有效日期为更新日期(第 3 字段) + 重新变更日期(第 5 字段)，过了该期限后用户依旧没有更新密码，那该密码就过期。虽然密码过期但是该账号还是可以用来进行其他工作的，包括登入系统取得bash。但当用户登入系统时，系统会强制要求必须要重新设定密码才能登入

* **8. 账号失效日期：** 账号在此字段规定的日期(即填以 1970 年为基准，两者相隔的天数)之后，将无法再使用。即账号失效，此时不论你的密码是否有过期，这个账号都不能再使用

* **9. 保留：** 保留字段，看以后有没有新功能加入。

**例子(来源于鸟哥的 Linux 私房菜)：**
![shadow1.png](https://i.loli.net/2021/05/15/vTCEOJNHxtno4Wa.png)
注：16559 为 2015/05/04
***以上代码的意义为：***
* 由于密码几乎仅能单向运算（由明码计算成为密码，无法由密码反推回明码），因此由上表的资料我们无法得知 dmstai 的实际密码明文（第二个字段）

* 此账号最近一次更动密码的日期是 2015/05/04（16559）

* 能够再次修改密码的时间是 5 天以后，也就是2015/05/09 以前 dmtsai 不能修改自己的密码。如果用户还是尝试更动自己的密码，系统就会出现这样的讯息：
`You must wait longer to change your password`
`passwd: Authentication token manipulation error`

* 由于密码过期日期定义为 60 天后，亦即为：16559+60=16619 (2015/07/03) 。 这表示：*用户必须要在 2015/05/09（前 5 天不能改）到 2015/07/03 之间的 60 天限制内去修改自己的密码，若 2015/07/03 之后还是没有变更密码时，该密码就过期*

* 警告日期设为 7 天，亦即是密码过期日前的 7 天，在本例中则代表 2015/06/26 ~ 2015/07/03 这七天。如果用户一直没有更改密码，那么在这 7 天中，只要 dmtsai 登录系统就会发现如下的警告：
`Warning: your password will expire in 5 days`

* 如果该账号一直到 2015/07/03 都没有更改密码，那么密码就会过期。但由于有 5 天的宽限天数，因此dmtsai 在 2015/07/08 前都还可以使用旧密码登入主机。不过登入时会出现强制更改密码的情况，画面有点像底下这样：
`You are required to change your password immediately (password aged)`
`WARNING: Your password has expired.`
`You must change your password now and login again!`
`Changing password for user dmtsai.`
`Changing password for dmtsai`
`(current) UNIX password:`
你必须要输入一次旧密码以及两次新密码后，才能够开始登入系统。如果你是在 2015/07/08 以后尝试以 dmtsai 登入的话，那么就会出现如下的错误讯息且无法登入，因为此时你的密码已经失效
`Your account has expired; please contact your system administrator`

* 如果用户在 2015/07/03 以前变更过密码，那么第 3 个字段的天数就会跟着改变，因此，所有的限制日期也会跟着相对变动

* 无论用户如何动作，到了 16679 (大约是 2015/09/01 左右）该帐号就失效

---
## 群组
群组分为有效群组(effective group)、初始群组(initial group)和支持群组(support groups)

* 支持群组(support groups)：每个使用者都可以拥有多个支持的群组，并拥有该群组的功能。

* 有效群组(effective group): 当前用户所使用的群组，一般为初始群组。影响文件的建立等

* 初始群组(initial group)：一般为账号创建时同时在`/etc/group`创建的群组。该群组与账号同名。一般作为账号登录时的群组

### 群组文件 /etc/group 与 /etc/gshadow
#### /etc/group 结构
![group.png](https://i.loli.net/2021/05/16/5S1G6MkQBDUlOFu.png)

`/etc/group` 以 : 进行分割，以下为字段详细说明：

* **1. 组名：** 群组名字，需要与第三字段的 GID 对应。一般也等同于 `/etc/passwd` 中的账号名
* **2. 群组密码：** 通常不需要设定，设定了是给群组管理员使用的，但因为存在 `sudo` 命令，目前很少有机会设定群组管理员。密码同样经移动到 /etc/gshadow 中，因此这个字段只会存在一个 x 
* **3. GID：** 群组 ID 。与 /etc/passwd 第四个字段使用的 GID 对应
* **4. 此群组支持的账号名称：** 一个账号可以加入多个群组，那某个账号想要加入此群组时，将该账号填入这个字段即可。 如果想要让 alex 与 jacky 也加入 ryan 这个群组，只需填写成这样 `ryan:x:0:alex,jacky` 

PS: 新版的 Linux 中，初始群组的用户群已经不会加入在自身的群组的第四个字段

#### /etc/gshadow 文件结构
![gshadow.png](https://i.loli.net/2021/05/16/ZvDanlWKk4Qi6mL.png)

`/etc/gshadow` 以 : 进行分割，以下为字段详细说明：

* **1. 组名：** 群组名字，与 `/etc/group` 对应
* **2. 密码栏：** 开头为 ! 或该字段为空，表示无合法密码，即无群组管理员
* **3. 群组管理员的账号：** 管理该群的管理员账号
* **4. 有加入该群组支持的所属账号：** 与 /etc/group 内容相同

PS：`/etc/gshadow` 最大的功能就是建立群组管理员，但因为有类似 `sudo` 之类的工具， 群组管理员的功能已经很少使用

### 有效群组的确定与切换
#### 有效群组的确定：groups
因为一个账号可以有多个支持群组。可以使用`groups`确定目前有效群组

用法：`groups`

![groups.png](https://i.loli.net/2021/05/16/zGpErNY1c4QakWP.png)

PS：一般第一个为当前有效群组，即当用户建立文档或目录时，改文档或目录属于当前有效群组

#### 有效群组的切换：newgrp
当用户需要切换自己的有效群组时，可以使用 `newgrp` 进行切换。但只能将账号支持群组切换为有效群组

用法：`newgrp 群名`

![newgrp.png](https://i.loli.net/2021/05/16/wrI3JUi8lbudL4y.png)

PS：用户切换有效群组，实际上是另外以一个 shell 来提供这个功能。虽然用户的环境设定(例如环境变量等等其他数据)不会有影响，但是用户的群组权限将会重新被计算。因此如果你想要回到原本的环境中，需要用`exit`

用户切换有效群组图片说明(来自于鸟哥的Linux)：
![newgrp.gif](https://linux.vbird.org/linux_basic/centos7/0410accountmanager/newgrp.gif)

## /etc/passwd、/etc/group/与/etc/shadow 三者关系
![centos7_id_link](
https://linux.vbird.org/linux_basic/centos7/0410accountmanager/centos7_id_link.jpg)^图片来自于鸟哥的Linux^

图中 root 的 UID 是 0 ，而 GID 也是 0 ，通过 `/etc/group` 可知 GID 为 0 时的组名为 root 。至于密码，则会找到 `/etc/shadow` 与 `/etc/passwd`内同名的那一行

# 账号与群组管理
## 新增账号
### 新增账号命令：useradd
用法：`useradd [-u UID] [-g 初始群组] [-G 支持群组] [-mM] [-c 说明栏] [-d 家目录绝对路径] [-s shell] 账号`

|选项与参数|说明|
|-|-|
|-u|后面接是 UID ，一组数字。直接指定一个特定的 UID 给这个账号|
|-g|后面接初始群组(initial group)，默认新建账号时会在 /etc/passwd 中新建同名的群组|
|-G|后面接支持群组(support groups)，即让新建的用户加入已存在的组|
|-M|强制不建立用户家目录(系统账号默认值)|
|-m|强制要建立用户家目录(一般账号默认值)，权限为700|
|-c|即 /etc/passwd 的第五栏的说明内容，可以随便设定|
|-d|指定某个目录成为家目录，而不要使用默认值。需绝对路径|
|-r|建立一个系统的账号，这个账号的 UID 会有限制 (参考 /etc/login.defs)|
|-s|后面用户可使用的 shell ，若没有指定则预设为 /bin/bash ；如果需要账号无法登录 shell ，可以使用 /bin/false 或 /sbin/nologin|
|-e|后面接一个日期，格式为 YYYY-MM-DD ，写入 shadow 第八字段，即账号失效日|
|-f|后面接 shadow 的第七字段项目，指定密码是否会失效。0 为立刻失效，-1 为永远不失效(密码只会过期而强制于登入时重新设定而已)|

#### useradd 的参考
##### 账号参数参考：/etc/default/useradd
使用 `useradd` 建立账号时的默认参数可以通过 `useradd -D` 来显示，所有参数都在 `/etc/default/useradd` 中

![useradd.png](https://i.loli.net/2021/05/22/HEsd5kh6XlNSrzm.png)

详细说明：
* GROUP=100：新建账号的初始群组使用 GID 为 100 
设定新设账号的初始群组为 GID 为 100 的组意思。但是不同发行版本对群组的角度有两种不同的机制，分别是：
  * 私有群组机制：
系统会建立一个与账号名称一样的群组作为初始群组。这种群组的设定机制会比较有保密性，家目录权限将会设定为 700 (仅有自己可进入自己的家目录) 。使用这种机制将不会参考 GROUP=100 这个设定值。代表的发行版本有 RHEL, Fedora, CentOS 等
  * 公共群组机制：
就是以 GROUP=100 这个设定值作为新建账号的初始群组，因此每个账号都属于 GID 为 100 的组，
且默认家目录通常的权限会是 `drwxr-xr-x ... username groupname ...` ，由于每个账号都属于 users 群组，因此大家都可以互相分享家目录内的数据之故。代表的发行版本有 SuSE 等

* HOME=/home：用户家目录的基准目录(basedir)
用户的家目录通常是与账号同名的目录，这个目录将会摆放在此设定值的目录后

* INACTIVE=-1：密码过期后是否会失效的设定值
与 `/etc/shadow` 的第七个字段密码失效日对应，如果是 0 代表密码过期立刻失效，如果
是 -1 则是代表密码永远不会失效，如果是数字，如 30 ，则代表过期 30 天后才失效

* EXPIRE=：账号失效的日期
与 `/etc/shadow` 的第八个字段账号失效日对应，通常不设定，但如果是付费的会员制系统，这个字段可以设定

* SHELL=/bin/bash：默认使用的 shell 程序文件名
新建账号是系统默认的 shell，如果不想账号可以登入，这里可以填写 /bin/false 或 /sbin/nologin

* SKEL=/etc/skel：用户家目录参考基准目录
指定用户家目录的参考基准目录。即新建一个账号是其家目录的参考，均由 /etc/skel 所复制过去。比如想以后新建的账号的环境都作出改变，可以编辑 /etc/skel/.bashrc

* CREATE_MAIL_SPOOL=yes：建立使用者的 mailbox
设定是否创建使用者邮箱

##### UID/GID密码参数参考：/etc/login.defs
UID/GID密码参数参考的是文件 `/etc/login.defs` 不建议对这个文件进行修改

![useradd2.png](https://i.loli.net/2021/05/22/tnOmb3W9iGF7yrA.png)

详细说明：
* **mailbox 所在目录：** 用户的默认 mailbox 文件放置的目录，即为/var/spool/mail

* **shadow 密码第 4, 5, 6 字段内容：** 设定账号在 `/etc/shadow` 中的4,5,6字段。其中 PASS_MIN_LEN 已失效，因为 PAM 的存在

* **UID/GID 指定数值：** 虽然 Linux 核心支持的账号高达 2^32^ 个，不过过多账号在管理上很麻烦，所以针对 UID/GID 的范围进行规范。注意：系统给予一个账号 UID 时， (1)先参考 UID_MIN 设定值取得最小数值； (2)由/etc/passwd 搜寻最大的 UID 数值， 将 (1) 与 (2) 相比，找出最大的那个再加一就是新账号的 UID 了。如果进行过手动指定 UID/GID，那么下一个账号的 UID/GID 会在这个之前手动指定的 UID/GID 基础上 +1 

* **用户家目录设定值：** 是否默认建立家目录

* **UMASK：** 家目录的初始权限

* **USERGROUPS_ENAB：** 是否在删除用户账号时删除初始群组(前提是该群组不在有其他账号)

* **ENCRYPT_METHOD：** 密码加密机制

## 新建账号的过程

* 在 /etc/passwd 里面建立一行与账号相关的数据，包括建立 UID/GID/家目录等；
* 在 /etc/shadow 里面将此账号的密码相关参数填入，但是尚未有密码；
* 在 /etc/group 里面加入一个与账号名称一模一样的组名；
* 在 /home 底下建立一个与账号同名的目录作为用户家目录，且权限为 700

## 修改账号密码
### 修改密码命令：passwd
新建完账号后是无法直接登录的，因为该账号还没有密码，需要使用 `passwd` 设置密码。密码设置建议如下：
* 密码不能与账号相同
* 密码尽量不要选用字典里面会出现的字符串
* 密码需要超过 8 个字符
* 密码不要使用个人信息，如身份证、手机号码、其他电话号码等
* 密码不要使用简单的关系式，如 1+1=2， Iamman 等
* 密码尽量使用大小写字符、数字、特殊字符($,_,-等)的组合

用法1：`passwd --stdin 账号`
用法2：`passwd [-l] [-u] [-S] [-n 天数] [-x 天数] [-w 天数] [-i 天数] 账号`

用法1详解：
![passwd.png](https://i.loli.net/2021/05/23/rv5MHXIEijG9sSe.png)
`passwd --stdin` 接收由前一个管道命令所得的 std output 作为 std input 。常用在 shell script 中。但不是每个 Linux 发行版都支持该命令

用法2详解：
|选项与参数|说明|
|-|-|
|-l| Lock 的意思，会将 /etc/shadow 第二栏最前面加上 ! 使密码失效|
|-u|与 -l 相对，即 Unlock 的意思|
|-S|列出密码相关参数，即 shadow 文件内的大部分信息|
|-n|后面接天数，shadow 的第 4 字段，多长时间不可修改密码|
|-x|后面接天数，shadow 的第 5 字段，多长时间内必须要更动密码|
|-w|后面接天数，shadow 的第 6 字段，密码过期前的警告天数|
|-i|后面接天数，shadow 的第 7 字段，密码失效日期|

PS:
1. 用户自行修改密码，只需输入 `passwd` 命令即可，然后输入当前密码跟两次新的密码，出现 successfully 字样说明修改成功。出现在输入完新的密码后没出现 Retype 而出现 New，说明新密码无法通过 PAM 模块检验，需要重新输入新密码
2. root 用户修改任何(自身或其他用户)密码不需要键入当前密码，而是直接键入新密码

#### 一些关于 `passwd` 命令的例子
![passwd2.png](https://i.loli.net/2021/05/23/QaDdJGTIE4WLClm.png)

## 账号管理：查看、修改、删除
### 查看账号详细信息：chage
用法：`chage [-ldEImMW] 账号`

|选项与参数|说明|
|-|-|
|-l|列出该账号的详细密码参数|
|-d|后面接日期，修改 shadow 第三字段(最近一次更改密码的日期)，格式 YYYY-MM-DD|
|-E|后面接日期，修改 shadow 第八字段(账号失效日)，格式 YYYY-MM-DD|
|-I|后面接天数，修改 shadow 第七字段(密码失效日期)|
|-m|后面接天数，修改 shadow 第四字段(密码不可被改动天数)|
|-M|后面接天数，修改 shadow 第五字段(密码多久需要进行变更)|
|-W|后面接天数，修改 shadow 第六字段(密码过期前警告天数)|

![chage.png](https://i.loli.net/2021/05/23/gWqcyGslVUOinXS.png)

PS：如果想要新建用户第一次登录时需要修改密码，可先设置一个密码给改账号，然后用 `chage -d 0 账号` 将账号的最后一次更改密码日期设置为 0 即可

### 修改账号信息：usermod
用法：`usermod [-cdegGlsuLU] 账号`

|选项与参数|说明|
|-|-|
|-c|接账号的说明，即 /etc/passwd 第五栏说明栏|
|-d|接账号的家目录，修改 /etc/passwd 的第六栏，账号默认家目录|
|-e|接日期，格式是 YYYY-MM-DD 即修改 /etc/shadow 的第 8 个字段(账号失效日)|
|-f|接天数，即修改 shadow 的第七字段(密码失效日)|
|-g|接初始群组，修改 /etc/passwd 的第四个字段(初始群组)，即 GID 的字段|
|-G|接次要群组，修改这个账号能够支持的群组，即修改的是 /etc/group|
|-a|与 -G 合用，可增加次要群组的支持而非设定|
|-l|接账号名称。即是修改账号名称，/etc/passwd 的第一个字段|
|-s|接 Shell 的实际文件，如 /bin/bash 或 /bin/csh 等等|
|-u|接 UID ，即 /etc/passwd 第三个字段|
|-L|暂时将用户的密码冻结，让他无法登入。即改 /etc/shadow 的第二个字段(在第二个字段前添加 ! )|
|-U|将 /etc/shadow 密码栏的 ! 拿掉，解冻账号|

### 删除账号：userdel
用法：`userdel [-r] 账号`

|选项与参数|说明|
|-|-|
|-r|连同用户的家目录也一起删除|

PS：
1. 删除账号时确定账号不再使用时才删除，如果只是暂时不用，建议将账号设为过期
2. 建议删除前先使用 `find / -user 账号` 先找出该账号所有拥有的文件进行删除，再删除该账号

## 用户可用的账号管理命令
以下是几个用户可能的账号管理命令，其权限均为 SUID

### 查询简单账号信息：ID
用法：`ID 账号`
![id.png](https://i.loli.net/2021/05/29/3ivfpnyXcLmYqBC.png)

### 查询详细账号信息：finger
注意：`finger` 命令在很多发行版上是默认不安装的，因为 `finger` 命令实际上是读取 `/etc/passwd` 里面的信息

用法：`finger [-sm] 账号`

|选项与参数|解析|
|-|-|
|-s|仅列出用户的账号、全名、终端机代号与登入时间等等|
|-l|显示用户的用户名、真实姓名、用户家目录、登录后的shell、登录时间、电子邮件、计划文件|
|-p|和-l一样，但是不显示.plan、.project、.pgpkey文件|
|-m|不查找用户真实姓名|

### 修改 finger 信息：chfn
`chfn` 参数也是默认不安装，改命令只用于修改 `finger` 显示的信息，实际上也是修改 `/etc/passwd` 中的第五个字段(用户信息栏)

用法：`chfn [-foph] 账号`

|选项与参数|解析|
|-|-|
|-f|后面接完整的大名|
|-o|办公室的房间号码|
|-p|办公室的电话号码|
|-h|家里的电话号码|

### 修改账号默认 shell：chsh
用法：`chsh [-ls] 账号`

|选项与参数|解析|
|-|-|
|-l|列出目前系统上面可用的 shell ，即 /etc/shells 的内容|
|-s|修改自己的 Shell |

## 群组管理：新增与删除
### 新增群组：groupadd
用法：`groupadd [-g gid] [-r] 群名`

|选项与参数|解析|
|-|-|
|-g|接特定的 GID ，用来直接将这个 GID 给予到 group|
|-r|建立系统保留群组，与 /etc/login.defs 内的 GID_MIN 有关|

### 修改群组：groupmod
用法：`groupmod [-g gid] [-n group_name] 群组名`

|选项与参数|解析|
|-|-|
|-g|修改 GID |
|-n|修改组名|

### 删除群组：groupdel
用法：`groupdel 群名`

PS：如果删除一个群名是提示无法删除，可能群名在被使用，可通过 GID 在 `/etc/passwd` 跟 '/etc/group' 中查看

### 管理群组：gpasswd
管理员可用命令：`gpasswd [-A user1,...] [-M user3,...] [-rR] 群名`

|选项与参数|解析|
|-|-|
||如果直接群名，没有任何参数时，表示给予该群一个密码(/etc/gshadow)|
|-A|将群的主控权交由后面的账号管理(该账号为群组的管理员)|
|-M|将账号加入到群组中|
|-r|移除该群组的密码|
|-R|让群组的密码栏失效|

群管理员可用命令：`gpasswd [-ad] 账号 群组`

|选项与参数|解析|
|-|-|
|-a|将账号加入到群组当中|
|-d|将账号移除出群组当中|

# 权限的细致划分：ACL
传统的Linux权限只有rwx三种，如果需要对单一用户、群组以及文件/目录进行权限设置，就需要用到ACL(Access Control List)

ACL(Access Control List) 主要的目的是提供传统的 owner,group,others 的 read,write,execute 权限之外更精细的权限设定。ACL 可以针对单一使用者，单一文件/目录来进行 r,w,x 的权限规范。ACL 针对不同项目可以不同的权限划分：
* 用户 (user)：可以针对特定用户设置权限
* 群组 (group)：可以针对特定群组设置权限
* 默认属性 (mask)：可以针对在该目录下新建文件/目录时，规范新数据的默认权限

在众多 Linux 发行版本中，ACL 是默认支持并启动的，可以使用使用 `dmesg | grep -i acl` 查看(Debian发行版不一定支持该命令)

### 设置ACL：setfacl
用法：`setfacl [-bkRd] [{-m|-x} acl 参数] 文件名`
针对特定账号用法：`setfacl [参数] -m u:账号名:权限(rwx/-) 文件名`
针对特定群组用法：`setfacl [参数] -m g:群组名:权限(rwx/-) 文件名`
针对有效权限 mask 用法：`setfacl [参数] -m m:权限(rwx/-) 文件名`
针对预设权限用法：`setfacl [参数] -m d:[ug]:名称:权限(rwx/-) 文件名`

|选项与参数|解析|
|-|-|
|-m|设置 acl 参数，不可与 -x 合用|
|-x|删除 acl 参数，不可与 -m 合用。用法 `serfacl -x [ug]:名称 文件名`|
|-b|移除所有 ACL 设定参数|
|-k|移除预设 ACL 参数|
|-R|递归设定 acl |
|-d|设定预设 acl 参数，只对目录有效，在该目录下新建的文件/目录会引用此默认值|

PS：
1. 有效权限(mask)：账号或群组所设定的权限必须要与 mask 的权限设定重叠才会生效。如：user1 对于 A 文件夹的 ACL 权限为 rx；group1 对于 A 文件夹的 ACL 权限为 rw；但是 mask 的 ACL 权限仅为 r，那么 user1 跟 group1 的 ACL 权限仅有 r 生效。

2. ACL 权限默认是没有继承的，需要继承 ACL 权限，就要用针对预设权限的设定方式来设定 ACL

### 查看ACL：getfacl
用法：`getfacl 文件名`

# Linux 账号切换
一般情况下，登入到 Linux 系统是使用一般账号登录，主要原因有以下：
* 避免使用 root 账号误操作
* 提高系统安全性

在一般账号下需要切换到 root 账号，可以使用 `su` 命令或 `sudo` 命令

* `su -` 直接将身份变成 root ，但是这个命令需要 root 的密码

* `sudo 命令` 执行 root 的命令，由于 sudo 需要事先设定妥当，且 sudo 需要输入用户自己的密码，因此多人共管同一部主机时 `sudo` 命令更加安全

## 账号切换命令：su
用法：`su [-lm] [-c 命令] 用户名`

|选项与参数|解析|
|-|-|
|-|单纯使用 - ，如 `su -` 代表使用 login-shell 的变量文件读取方式来登入系统（即完整切换。会变更环境变量，不适用当前账号的环境变量）；若没有加上账号名称，则代表切换为 root 的身份|
|-l|与 - 类似，但后面需要加欲切换的使用者账号，也是 login-shell 的方式，所需输入的密码为切换的账号的密码|
|-m|-m 与 -p 是一样的，表示使用目前的环境设定，而不读取新使用者的配置文件|
|-c|仅进行一次指令，所以 -c 后面可以加上命令，如 `su - -c "命令"`，密码为需要用到的账号的密码|

PS：
1. 使用 root 账号切换其他账号时不需要输入密码

## 账号权限切换（提权）：sudo
`sudo` 命令与 `su` 命令不同，`su` 命令是切换到其他账号，而 `sudo` 命令是使用其他账号权限。

能否使用 `sudo` 必须要看 /etc/sudoers 的设定值，而可使用 `sudo` 者是透过输入用户自己的密码来执行后续的命令

用法：`sudo [-b] [-u 新账号]`

|选项与参数|解析|
|-|-|
|-b|将后续的命令放到背景中让系统自行执行，而不与目前的 shell 产生影响
|-u|后面可以接欲切换的使用者，若无此项则代表切换身份为 root|

* 例子1：利用 sshd 身份在 /tmp 下建立 mysshd 文件
![sudo.png](https://i.loli.net/2021/06/06/Fzb2dpEkyOGUBlY.png)

* 例子2：利用 Ryan 身份在家目录下创建一个文件夹，文件夹中包含一个 html 文件
![sudo2.png](https://i.loli.net/2021/06/06/PGKLhdy2bc458Ie.png)
  * PS: 使用 `sh -c` 是因为 `sudo` 只让后面接着的命令有 `sudo` 权限。因为这个例子涉及到多个命令。 `sh -c` 可以让 bash 将一个字串作为完整的命令来执行，这样就可以将 sudo 的影响范围扩展到整条命令

### sudo 命令执行流程：
1. 当用户执行 `sudo` 时，系统于 /etc/sudoers 文件中搜寻该用户是否有执行 sudo 的权限
2. 若用户具有可执行 `sudo` 的权限后，则让用户输入用户自己的密码来确认
3. 若密码输入成功，便开始进行 sudo 后续接的指令(但 root 执行 sudo 时，不需要输入密码)
4. 若切换的身份与执行者身份相同，则不需要输入密码
5. 注意 `sudo` 命令执行后，如果再次执行 `sudo` 命令距离上一次不足5分钟，不需要输入密码


### /etc/sudoers 与 visudo
除了 root 之外的其他账号，想要使用 sudo 执行属于 root 的权限命令(提权)，则 root 需要先修改 /etc/sudoers ，让该账号能够使用全部或部分的 root 命令功能。因为 /etc/sudoers 文件具有设定语法，建议使用 `visudo` 去修改 /etc/sudoers（实际上 `visudo` 就是用 `vi` 去修改 /etc/sudoers）

#### 关于 visudo 的几种设定方法
1. 单一用户可进行 root 所有命令（设定大约在 `visudo` 的100行）：
![visudo.png](https://i.loli.net/2021/06/06/C1URaqYTQfrlSHF.png)
   * 1. 账号：系统的哪个账号可以使用 sudo 这个指令的意思；
   * 2. 登入的来源主机：账号由哪部主机联机到本 Linux 主机。意思是这个账号可能是由哪一部网络主机联机过来的，这个设定值可以指定客户端计算机(信任的来源的意思)。默认值 root 可来自任何一部网络主机
   * 3. (可获取权限的身份)：这个账号可以获取哪些身份的权限来下达后续的命令，默认 root 可以获取任何身份权限
   * 4. 可下达的命令：可用该身份下达什么命令。这个命令请务必使用绝对路径。预设 root 可以获取任何身份权限且进行任何命令

2. 利用 wheel 群组设定 sudo（设定大约在 `visudo` 的106行）：
![visudo2.png](https://i.loli.net/2021/06/06/kKItrEvi4bfQARX.png)
   * 图中意思为任何加入 wheel 这个群组的账号，就能够使用 sudo 获取任何身份权限来执行任何命令，因为 wheel 群组已经被设置在 visudo 文件中（%代表后面接的是群组的意思）

3. 群组免密进行 sudo 提权（设定大约在 `visudo` 的109行）：
![visudo3.png](https://i.loli.net/2021/06/06/oOM2j1tFlhTXZid.png)

4. 有限的命令操作：
![visudo4.png](https://i.loli.net/2021/06/06/i7D9P3qvjmVeQbw.png)
   * 在可下达的命令中填入命令（命令必须是**绝对路径**）后，该账号只能通过提权执行填入的命令。其中 ! 代表不可执行的命令。因此图中填入的意思为：可以执行 `passwd 任意字符`，但是 `passwd` 与 `passwd root`这两个命令除外

5. 通过别名设置 visudo：
![visudo5.png](https://i.loli.net/2021/06/06/a7fR9j6BOqIWQLn.png)
   * 可通过User_Alias(账号别名)、Cmnd_Alias(命令别名)、Host_Alias(来源主机名别名)来进行别名设置。别名后定义的名称必须是**大写**

6. visudo 与 su 结合使用
![visudo6.png](https://i.loli.net/2021/06/06/EQwa2BKCLvY4DrJ.png)
   * 通过上述设置后，进行 `su -` 命令时不再需要输入 root 的密码

# Linux 传递用户信息
## 查看当前登录用户：w,who,last,lastlog
命令：`w`
命令：`who`
命令：`last`
命令：`lastlog`

## 登录用户直接对话：write,mesg,wall
命令：`write 账号 用户所在终端端口`
* `write` 命令输入后会让你输入需要发送给用户的信息。输入完后以 <kbd>ctrl</kbd> + <kbd>c</kbd> 结束

命令：`mesg [n|y]`
* 当命令 `mesg` 设置为 n 时，代表用户不接受任何的信息，即无法通过 `write` 给用户发送信息(除了 root 用户)

命令：`wall 信息`
* `wall` 命令用于给全体用户广播信息

## 邮件信箱：mail
每个用户都会有自己的 mailbox，放置于 `/var/spool/mail` 中。

发送邮件命令：`mail -s "邮件标题" username@localhost`
* 邮件最后一行输入小数点，可以结束邮件的输入。当然邮件也支持数据流重定向的小于号(<)输入邮件主题，或管道符输入也可以

查看邮件命令：`mail`
在 mail 当中的提示字符是 & , > 代表目前处理的信件， N 代表该封信件未读。可以在 & 之后输入 ? 得到 `mail` 的内部指令：
|指令|意义|
|-|-|
|h|列出信件标头；如果要查阅 40 封信件左右的信件标头，可以输入 `h 40` |
|d|删除后续接的信件号码，删除单封是 `d10` ，删除 20~40 封则为 `d20-40` 。必须要配合 q 使用|
|s|将信件储存成文件。例如我要将第 5 封信件的内容存成 ~/mail.file: `s 5 ~/mail.file` |
|x|或者输入 exit 。不作任何动作离开 mail 的意思。不论你刚刚删除了什么信件，或者读过什么，使用 exit 都会直接离开 mail|
|q|离开并进行你刚刚所执行的任何动作|

PS：<message list> 指的是每封邮件的左边那个数字