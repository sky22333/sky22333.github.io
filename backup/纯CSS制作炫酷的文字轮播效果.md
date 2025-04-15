### 示例代码
```
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>文字动画示例</title>
  <style>
    @import url("https://fonts.googleapis.com/css2?family=Protest+Revolution&display=swap");

    main {
      height: 100vh;
      background: #333;
      filter: contrast(30);
      position: relative;
    }

    .text {
      --text-node-count: 3;
      --single-duration: 1.2s;
      color: #fff;
      font-size: 8em;
      font-family: "Protest Revolution", sans-serif;
      font-weight: 400;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      letter-spacing: 4px;
      animation: ani calc(var(--text-node-count) * var(--single-duration)) infinite;
      animation-delay: calc(
        (var(--i) * var(--single-duration)) - var(--text-node-count) * var(--single-duration)
      );
    }

    @keyframes ani {
      0%, 100% {
        color: #fff;
        filter: blur(0);
        opacity: 1;
      }

      35%, 55% {
        filter: blur(35px);
        opacity: 0;
      }
    }
  </style>
</head>
<body>
  <main>
    <p class="text" style="--i:1">Where</p>
    <p class="text" style="--i:2">possible</p>
    <p class="text" style="--i:3">begins</p>
  </main>
</body>
</html>
```


来源：https://linux.do/t/topic/560383