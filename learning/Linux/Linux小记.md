## 终端显示中文问题
可以用`locale`查看，然后用`LANG` 跟 `export LC_ALL` 修改
或修改`/etc/licale.config`

---
## su 切换注意
`su`的切换必须是用`su -`进行切换。如果只用`su`切换，只是临时激活了root权限，环境还是之前的用户的。只有通过`su -`切换到root并且切换到root的环境才可以

---
## tty切换
可以通过<kbd>ctrl</kbd> + <kbd>alt</kbd> + <kbd>F1 ~ F7</kbd>切换tty1 ~ tty7

---
## ll链接目录的问题
当`ll 链接目录`时，如果是输入了`ll name/`，显示的是实际文档的信息，如果