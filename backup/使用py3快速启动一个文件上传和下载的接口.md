### 安装py3
```
sudo apt update
sudo apt install python3 python3-pip -y
```

### 配置`upload.py`
```
from flask import Flask, request, render_template_string
import os

app = Flask(__name__)
UPLOAD_FOLDER = '.'  # 设置上传目录为当前工作目录
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

HTML = '''
<!doctype html>
<title>文件上传</title>
<h1>上传文件</h1>
<div id="drop-area">
    <form id="form" method="post" enctype="multipart/form-data">
        <input type="file" id="fileElem" multiple accept="*/*" style="display:none;" onchange="handleFiles(this.files)">
        <label for="fileElem">选择文件</label>
        <div id="gallery"></div>
    </form>
</div>
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
        fetch('/', { method: 'POST', body: formData })
            .then(response => response.text())
            .then(data => console.log(data));
    }
</script>
<style>
    #drop-area { border: 2px dashed #ccc; padding: 20px; text-align: center; }
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
    app.run(host='0.0.0.0', port=8000)
```

- 安装 Flask
```
pip install Flask
```
- 运行
```
python upload.py
```

默认端口为`8000`，支持拖拽上传和文件夹上传


### 临时下载
- cd到文件目录
```
python3 -m http.server 8000
```