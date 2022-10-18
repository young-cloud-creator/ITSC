# iw02

请基于模板工程，为https://itsc.nju.edu.cn开发一个iOS客户端。

功能要求如下：

1. App界面设计见模板工程的Main Storyboard，首届面通过tab bar controller分为5个栏目
2. 前4个分别对应网站4个信息栏目（如下），下载list.htm内容并将新闻条目解析显示在Table View中
   - https://itsc.nju.edu.cn/xwdt/list.htm
   - https://itsc.nju.edu.cn/tzgg/list.htm
   - https://itsc.nju.edu.cn/wlyxqk/list.htm
   - https://itsc.nju.edu.cn/aqtg/list.htm
3. 点击table view中任意一个cell，获取该cell对应新闻的详细内容页面，解析内容并展示在内容详情场景中
4. 最后一个栏目显示 https://itsc.nju.edu.cn/main.htm 最后“关于我们”部分的信息

非功能需求如下：
1. 界面美观（通过自动化布局适配多种设备）
2. 性能良好（用GCD进行并发编程，网络通信应考虑缓冲已下载数据内容）

