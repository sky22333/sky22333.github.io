  (function() {
    var currentDomain = window.location.hostname;
    if (currentDomain !== 'blog.52013120.xyz') {
      var modal = document.createElement('div');
      modal.style.position = 'fixed';
      modal.style.top = '0';
      modal.style.left = '0';
      modal.style.width = '100%';
      modal.style.height = '100%';
      modal.style.backgroundColor = 'rgba(0, 0, 0, 0.8)';
      modal.style.display = 'flex';
      modal.style.alignItems = 'center';
      modal.style.justifyContent = 'center';
      modal.style.zIndex = '9999';
      var modalContent = document.createElement('div');
      modalContent.style.backgroundColor = '#fff';
      modalContent.style.padding = '20px';
      modalContent.style.borderRadius = '10px';
      modalContent.style.textAlign = 'center';
      modalContent.style.maxWidth = '90%';
      modalContent.style.fontSize = '20px';
      modalContent.style.color = '#333';
      modalContent.innerHTML = 'blog.52013120.xyz';
      modal.appendChild(modalContent);
      document.body.appendChild(modal);
      setTimeout(function() {
        window.location.href = 'https://blog.52013120.xyz';
      }, 3000);
    }
  })();
