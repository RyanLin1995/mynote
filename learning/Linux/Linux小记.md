## 终端显示中文问题
可以用`locale`查看，然后用`LANG` 跟 `export LC_ALL` 修改
或修改`/etc/licale.config`

---
## su 切换注意
`su`的切换必须是用`su -`进行切换。如果只用`su`