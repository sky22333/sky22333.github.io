### 安装py3
```
sudo apt update
sudo apt install python3 python3-pip -y
```

### 配置`up.py`
```
from flask import Flask, request, render_template_string
import os
app = Flask(__name__)
# 设置上传目录为当前目录
UPLOAD_FOLDER = '.'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
# 限制上传文件大小100MB
app.config['MAX_CONTENT_LENGTH'] = 100 * 1024 * 1024

HTML = '''
<!doctype html>
<title>文件上传 </title>
<h1>上传文件(最大100MB)</h1>
<div id="drop-area" onclick="document.getElementById('fileElem').click();">
    <form id="form" method="post" enctype="multipart/form-data">
        <input type="file" id="fileElem" multiple accept="*/*" style="display:none;" onchange="handleFiles(this.files)">
        <label for="fileElem">选择文件</label>
        <div id="gallery"></div>
    </form>
</div>
<div id="message" style="color: green; margin-top: 10px;"></div>
<script>
    let dropArea = document.getElementById('drop-area');
    dropArea.addEventListener('dragover', event => {
        event.preventDefault();
    });
    dropArea.addEventListener('drop', event => {
        event.preventDefault();
        handleFiles(event.dataTransfer.files);
    });

    function handleFiles(files) {
        const formData = new FormData();
        for (let file of files) {
            formData.append('file', file);
            const listItem = document.createElement('div');
            listItem.textContent = file.name;
            document.getElementById('gallery').appendChild(listItem);
        }
        document.getElementById('message').textContent = '上传中...';
        fetch('/', { method: 'POST', body: formData })
            .then(response => response.text())
            .then(data => {
                document.getElementById('message').textContent = data;
            })
            .catch(() => {
                document.getElementById('message').textContent = '上传失败！';
            });
    }
</script>
<style>
    #drop-area { border: 2px dashed #ccc; padding: 20px; text-align: center; cursor: pointer; }
</style>
'''

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        for f in request.files.getlist('file'):
            f.save(os.path.join(UPLOAD_FOLDER, f.filename))
        return '文件上传成功！'
    return render_template_string(HTML)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
```

- 安装 Flask
```
pip install Flask
```
- 运行
```
python up.py
```

端口为`8080`，支持拖拽和选择上传


### 临时下载
- cd到文件目录
```
python3 -m http.server 8080
```