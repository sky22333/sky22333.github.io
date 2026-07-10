**要在Cloudflare WAF免费计划中添加屏蔽国内浏览器的规则，请按照以下步骤操作。这个规则基于用户代理字符串来屏蔽特定的浏览器。以下是具体的步骤和完整的规则表达式：**

步骤：
- **登录到 Cloudflare Dashboard**
- **选择托管的域名**
- **在左侧导航栏中选择 `Security`**
- **点击 `WAF`**
- **选择 `Custom rules`**
- **点击 `Create rule`**
- **在 `Expression preview` 右侧点击 `Edit expression`**
- **复制以下规则表达式**


```
(http.user_agent contains "115Browser") or 
(http.user_agent contains "2345chrome") or 
(http.user_agent contains "2345Explorer") or 
(http.user_agent contains "360EE") or 
(http.user_agent contains "360SE") or 
(http.user_agent contains "AliApp") or 
(http.user_agent contains "Baidu") or 
(http.user_agent contains "BaiduHD") or 
(http.user_agent contains "baidubrowser") or 
(http.user_agent contains "baiduboxapp") or 
(http.user_agent contains "baidu") or 
(http.user_agent contains "BIDUBrowser") or 
(http.user_agent contains "com.douban.frodo") or 
(http.user_agent contains "DingTalk") or 
(http.user_agent contains "HarmonyOS") or 
(http.user_agent contains "HUAWEI") or 
(http.user_agent contains "HuaweiBrowser") or 
(http.user_agent contains "huawei") or 
(http.user_agent contains "IqiyiApp") or 
(http.user_agent contains "LBBROWSER") or 
(http.user_agent contains "LieBaoFast") or 
(http.user_agent contains "Mb2345Browser") or 
(http.user_agent contains "MetaSr") or 
(http.user_agent contains "MicroMessenger") or 
(http.user_agent contains "MiuiBrowser") or 
(http.user_agent contains "MZBrowser") or 
(http.user_agent contains "OppoBrowser") or 
(http.user_agent contains "QHBrowser") or 
(http.user_agent contains "QihooBrowser") or 
(http.user_agent contains "QQ") or 
(http.user_agent contains "QQBrowser") or 
(http.user_agent contains "Quark") or 
(http.user_agent contains "SNEBUY-APP") or 
(http.user_agent contains "Sogou") or 
(http.user_agent contains "SP-engine") or 
(http.user_agent contains "TheWorld") or 
(http.user_agent contains "UC") or 
(http.user_agent contains "UCBrowser") or 
(http.user_agent contains "UCWEB") or 
(http.user_agent contains "UBrowser") or 
(http.user_agent contains "VivoBrowser") or 
(http.user_agent contains "WeChat") or 
(http.user_agent contains "Weibo") or 
(http.user_agent contains "Weixin") or 
(http.user_agent contains "wxwork")
```


**注意事项：**
- 区分大小写：Cloudflare WAF 的规则是区分大小写的，因此请确保所有用户代理字符串都使用正确的大小写格式。
- 验证规则：在应用规则之前，可以使用 Cloudflare 的表达式预览功能来验证规则的正确性和效果。
- 这个规则涵盖了大多数常见的国内浏览器用户代理字符串，并按照字母顺序进行了排序。如果有遗漏，可以根据需要进行补充。