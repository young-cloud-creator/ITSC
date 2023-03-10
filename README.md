# 概览

这是一个为 [itsc.nju.edu.cn](https://itsc.nju.edu.cn) 开发的iOS客户端，App共有新闻动态、通知公告、信息化动态、安全公告和关于5个Tab界面，对应于网站的[itsc.nju.edu.cn/xwdt](https://itsc.nju.edu.cn/xwdt/list.htm)、[itsc.nju.edu.cn/tzgg](https://itsc.nju.edu.cn/tzgg/list.htm)、[itsc.nju.edu.cn/wlyxqk](https://itsc.nju.edu.cn/wlyxqk/list.htm)、[itsc.nju.edu.cn/aqtg](https://itsc.nju.edu.cn/aqtg/list.htm)页面以及网站主页下方的关于信息。用户可以使用该应用更便捷地查看ITSC的相关动态。

# 项目结构

App共有新闻动态、通知公告、信息化动态、安全公告和关于5个Tab界面，这5个Tab界面均使用TableView布局，将ITSC网站的对应内容解析到表格单元中，解析通过正则表达式匹配和捕获组实现。

关于页面TableView的控制器为AboutTableViewController类，该控制器获取ITSC主页的html内容并将“关于我们”部分的信息解析并存储到AboutCellData类数组中，AboutCellData类包括标题、内容和描述三个字符串成员属性，用于存储信息。这样做的原因是ITSC主页“关于我们”部分的html内容为一个`<ul></ul>`标签包裹的表格，并且每个表格单元的内容格式一致，都具有标题、内容和描述三个信息。此外，AboutTableViewController重写了获取TableCell的方法，将解析得到的标题、内容和描述配置到AboutTableViewCell的对应Label中。

其余4个页面的功能高度一致，因此创建了一个TableViewController类来完成解析html等任务，并将内容存储在CellData类数组中。4个页面各自的Controller则继承自TableViewController，重写了viewDidLoad方法来指定要解析的url，重写了创建cell的方法来返回各个页面对应的TableViewCell对象。

除了关于页面无需跳转展示具体内容的功能，其他4个页面的列表条目均有跳转到具体内容的功能，它们共用一个内容展示界面来展示信息，这个界面的控制器是ContentViewController。界面由标题Label、时间Label和内容TextView三部分组成，ContentViewController从跳转的前一界面获得链接信息，然后获得链接对应的html并解析到对应的组件中。

# App功能与特性

每次启动App时从ITSC网站获取信息，无论是新闻动态还是关于页面，信息均来自于ITSC网站，从而总是与ITSC官网保持一致。App使用了自动化布局技术，而非硬编码组件的大小，因而能够适配不同屏幕尺寸的设备。网络信息获取不在主线程执行，不阻塞交互任务，因而避免了App无响应问题。新闻标题依据文字内容自动选择行数，因而不会出现新闻标题显示不全的问题。

App运行截图如下，

<table><tr>
  <td><img src="https://user-images.githubusercontent.com/84324349/203920363-9f5d1bd5-36ae-4be6-9029-ecef6ea28dad.png" width="300px"></td>
  <td><img src="https://user-images.githubusercontent.com/84324349/203920275-d00faa32-0fcb-45d1-9036-ae44b0e69f42.png" width="300px"></td>
  <td><img src="https://user-images.githubusercontent.com/84324349/203920457-6f306cf6-801c-474c-8423-ead5701ab413.png" width="300px"></td>
</tr></table>

<table><tr>
  <td><img src="https://user-images.githubusercontent.com/84324349/203920602-82ecd1f9-28a8-4a7a-91ea-0dd07f624652.png" width="300px"></td>
  <td><img src="https://user-images.githubusercontent.com/84324349/203920656-e5eac676-ebcc-4093-980b-34d8a8a0a8a4.png" width="300px"></td>
  <td><img src="https://user-images.githubusercontent.com/84324349/203920708-a935b2bc-9fb8-4034-88c2-c868707e9deb.png" width="300px"></td>
</tr></table>

App运行录屏如下，

https://user-images.githubusercontent.com/84324349/203921395-86ae2c1a-77f7-4e24-a583-e69b16d7238f.mov

