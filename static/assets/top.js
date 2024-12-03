(function() {
    const SITE_NAME = 'blog.52013120.xyz';
    const STORAGE_KEY = 'visitor_tracking';
    const TRACK_DURATION = 24 * 60 * 60 * 1000;

    function generateUniqueId() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0,
                v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    // 检查是否为新访客
    function isNewVisitor() {
        const visitorData = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');
        const currentTime = Date.now();

        // 如果没有记录或超过24小时，视为新访客
        if (!visitorData.id || (currentTime - visitorData.timestamp > TRACK_DURATION)) {
            const newVisitorData = {
                id: generateUniqueId(),
                timestamp: currentTime
            };
            localStorage.setItem(STORAGE_KEY, JSON.stringify(newVisitorData));
            return true;
        }

        return false;
    }

    // 创建计数器元素
    function createCounterElement() {
        const counterEl = document.createElement('div');
        counterEl.id = 'visitor-counter';
        counterEl.style.cssText = `
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background-color: rgba(0,0,0,0.7);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            z-index: 1000;
            width: auto;
            text-align: center;
        `;
        document.body.appendChild(counterEl);
    }

    // 获取并显示访客数
    function updateVisitorCount() {
        // 只有新访客才发送统计请求
        if (isNewVisitor()) {
            fetch(`https://api.countapi.xyz/hit/${SITE_NAME}/visitors`)
                .then(response => response.json())
                .then(data => {
                    const counterEl = document.getElementById('visitor-counter');
                    if (counterEl) {
                        counterEl.textContent = `访客数：${data.value}`;
                    }
                })
                .catch(error => {
                    console.error('获取访客数失败:', error);
                });
        } else {
            // 对于非新访客，仍然获取当前总数但不增加计数
            fetch(`https://api.countapi.xyz/get/${SITE_NAME}/visitors`)
                .then(response => response.json())
                .then(data => {
                    const counterEl = document.getElementById('visitor-counter');
                    if (counterEl) {
                        counterEl.textContent = `访客数：${data.value}`;
                    }
                })
                .catch(error => {
                    console.error('获取访客数失败:', error);
                });
        }
    }

    // 初始化
    function init() {
        createCounterElement();
        updateVisitorCount();
    }

    // 确保页面加载
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
