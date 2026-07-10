function createTOC() {
    var tocElement = document.createElement('div');
    tocElement.className = 'toc';
    var contentContainer = document.getElementById('content');
    
    const headings = contentContainer.querySelectorAll('h1, h2, h3, h4, h5, h6');
    
    if (headings.length === 0) {
        return;  // 如果没有标题元素，则不创建TOC
    }
    
    tocElement.insertAdjacentHTML('afterbegin', '<div class="toc-title">文章目录</div>');
    
    headings.forEach(heading => {
        if (!heading.id) {
            heading.id = heading.textContent.trim().replace(/\s+/g, '-').toLowerCase();
        }
        const link = document.createElement('a');
        link.href = '#' + heading.id;
        link.textContent = heading.textContent;
        link.className = 'toc-link';
        link.style.paddingLeft = `${(parseInt(heading.tagName.charAt(1)) - 1) * 10}px`;
        tocElement.appendChild(link);
    });
    
    tocElement.insertAdjacentHTML('beforeend', '<a class="toc-end" onclick="window.scrollTo({top:0,behavior: \'smooth\'});">Top</a>');
    contentContainer.prepend(tocElement);

    var toggleButton = document.createElement('button');
    toggleButton.className = 'toc-toggle';
    toggleButton.type = 'button';
    toggleButton.setAttribute('aria-label', '文章目录');
    toggleButton.setAttribute('aria-expanded', 'false');
    toggleButton.innerHTML = '<span></span><span></span><span></span>';
    toggleButton.addEventListener('click', function(event) {
        event.stopPropagation();
        var isOpen = tocElement.classList.toggle('toc-open');
        toggleButton.classList.toggle('toc-open', isOpen);
        toggleButton.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    });
    tocElement.addEventListener('click', function(event) {
        if (event.target.closest('a') && window.matchMedia('(max-width: 600px)').matches) {
            tocElement.classList.remove('toc-open');
            toggleButton.classList.remove('toc-open');
            toggleButton.setAttribute('aria-expanded', 'false');
        }
    });
    document.body.appendChild(toggleButton);

    document.addEventListener('click', function(event) {
        if (tocElement.classList.contains('toc-open') && !tocElement.contains(event.target) && !toggleButton.contains(event.target)) {
            tocElement.classList.remove('toc-open');
            toggleButton.classList.remove('toc-open');
            toggleButton.setAttribute('aria-expanded', 'false');
        }
    });
}

document.addEventListener("DOMContentLoaded", function() {
    createTOC();
    var css = `
    .toc {
        position:fixed;
        top:130px;
        left:50%;
        transform: translateX(50%) translateX(320px);
        width:200px;
        border: 1px solid #e1e4e8;
        border-radius: 6px;
        padding: 10px;
        overflow-y: auto;
        scrollbar-width: none;
        -ms-overflow-style: none;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        max-height: 70vh;
    }
    .toc::-webkit-scrollbar {
        display: none;
    }
    .toc-title{
        font-weight: bold;
        text-align: center;
        border-bottom: 1px solid #ddd;
        padding-bottom: 8px;
    }
    .toc-end{
        font-weight: bold;
        text-align: center;
        cursor: pointer;
        visibility: hidden;
    }  
    .toc a {
        display: block;
        color: var(--color-diff-blob-addition-num-text);
        text-decoration: none;
        padding: 5px 0;
        font-size: 14px;
        line-height: 1.5;
        border-bottom: 1px solid #e1e4e8;
    }
    .toc a:last-child {
        border-bottom: none;
    }
    .toc a:hover {
        background-color:var(--color-select-menu-tap-focus-bg);
    }
    .toc-toggle{
        display:none;
    }

    @media (max-width: 1249px) and (min-width: 601px)
    {
        .toc{
            position:static;
            top:auto;
            left:auto;
            transform:none;
            padding:10px;
            margin-bottom:20px;
        }
        .toc-toggle{
            display:none;
        }
    }

    @media (max-width: 600px)
    {
        .toc{
            position:fixed;
            right:16px;
            bottom:68px;
            top:auto;
            left:auto;
            width:min(280px, calc(100vw - 32px));
            max-height:min(60vh, 420px);
            margin:0;
            padding:10px;
            transform:translateY(12px) scale(.98);
            opacity:0;
            visibility:hidden;
            pointer-events:none;
            z-index:1000;
            background:var(--bgColor-default,var(--color-canvas-default));
            border-color:var(--borderColor-muted,var(--color-border-muted));
            box-shadow:0 12px 32px rgba(31,35,40,.18);
            transition:opacity .18s ease, transform .18s ease, visibility .18s ease;
        }
        .toc.toc-open{
            opacity:1;
            visibility:visible;
            pointer-events:auto;
            transform:translateY(0) scale(1);
        }
        .toc-toggle{
            display:flex;
            position:fixed;
            right:16px;
            bottom:16px;
            width:44px;
            height:44px;
            align-items:center;
            justify-content:center;
            flex-direction:column;
            gap:4px;
            border:1px solid var(--borderColor-muted,var(--color-border-muted));
            border-radius:50%;
            background:var(--bgColor-default,var(--color-canvas-default));
            color:var(--fgColor-default,var(--color-fg-default));
            box-shadow:0 8px 24px rgba(31,35,40,.16);
            z-index:1001;
            cursor:pointer;
            -webkit-tap-highlight-color:transparent;
        }
        .toc-toggle span{
            display:block;
            width:16px;
            height:2px;
            border-radius:999px;
            background:currentColor;
            transition:transform .18s ease, opacity .18s ease;
        }
        .toc-toggle.toc-open span:nth-child(1){
            transform:translateY(6px) rotate(45deg);
        }
        .toc-toggle.toc-open span:nth-child(2){
            opacity:0;
        }
        .toc-toggle.toc-open span:nth-child(3){
            transform:translateY(-6px) rotate(-45deg);
        }
    }`;

    const style = document.createElement('style');
    style.textContent = css;
    document.head.appendChild(style);

    window.onscroll = function() {
        const backToTopButton = document.querySelector('.toc-end');
        if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
            backToTopButton.style="visibility: visible;"
        } else {
            backToTopButton.style="visibility: hidden;"
        }
    };
});
