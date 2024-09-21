### 纯CSS实现剧透效果

**在Telegram客户端中，文字的`spoiler`效果可以通过特定的格式来实现。用户可以将某些文本标记为`spoiler`，使其在聊天中不直接显示，而是被一个模糊的、可点击的框包裹。我在网上搜了一些实现方法，以下是最简单的方法，并且比Telegram客户端更好看。**

- **在全局css 样式中定义如下样式**
```
.spoiler {
    position: relative; /* 使得伪元素可以定位 */
    background-color: rgba(200, 200, 200, 0.3); /* 浅灰色半透明背景 */
    color: rgba(0, 0, 0, 0.5); /* 半透明黑色文字 */
    user-select: none; /* 禁止选中文字 */
    overflow: hidden; /* 隐藏溢出的内容 */
    cursor: pointer; /* 鼠标悬停时光标变为手型 */
    filter: blur(3px); /* 添加模糊效果 */
    padding: 5px; /* 为文本添加内边距以增强效果 */
    transition: filter 0.3s ease; /* 添加平滑过渡效果 */
}

.spoiler:hover {
    background-color: inherit; /* 悬停时使用父元素的背景色 */
    color: inherit; /* 悬停时显示原色 */
    filter: blur(0); /* 悬停消除模糊效果 */
}
```
**保存即可。后面就是写文章时直接引用该class即可。**


- **例如使用`<span>`标签。比如原文是`快来看，这是一个剧透效果`，让`剧透效果`这四个字实现剧透效果**
```
快来看，这是一个<span class="spoiler">剧透效果</span>。
```