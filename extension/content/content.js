// Content script for L2L extension

// Inject save button into page
function injectSaveButton() {
  // Check if button already exists
  if (document.getElementById('l2l-save-button')) {
    return;
  }

  // Create save button
  const saveButton = document.createElement('div');
  saveButton.id = 'l2l-save-button';
  saveButton.innerHTML = `
    <div class="l2l-button-content">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M19 21H5C3.89543 21 3 20.1046 3 19V5C3 3.89543 3.89543 3 5 3H19C20.1046 3 21 3.89543 21 5V19C21 20.1046 20.1046 21 19 21Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M12 8V16" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
        <path d="M8 12H16" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
      </svg>
      <span>Save to L2L</span>
    </div>
  `;

  // Add styles
  saveButton.style.cssText = `
    position: fixed;
    bottom: 24px;
    right: 24px;
    z-index: 999999;
    background: #007aff;
    color: white;
    padding: 12px 20px;
    border-radius: 50px;
    box-shadow: 0 4px 12px rgba(0, 122, 255, 0.3);
    cursor: pointer;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 8px;
  `;

  // Add hover effect
  saveButton.addEventListener('mouseenter', () => {
    saveButton.style.transform = 'scale(1.05)';
    saveButton.style.boxShadow = '0 6px 16px rgba(0, 122, 255, 0.4)';
  });

  saveButton.addEventListener('mouseleave', () => {
    saveButton.style.transform = 'scale(1)';
    saveButton.style.boxShadow = '0 4px 12px rgba(0, 122, 255, 0.3)';
  });

  // Add click handler
  saveButton.addEventListener('click', () => {
    // Open extension popup
    chrome.runtime.sendMessage({ action: 'openPopup' });
  });

  // Add to page
  document.body.appendChild(saveButton);
}

// Remove save button
function removeSaveButton() {
  const button = document.getElementById('l2l-save-button');
  if (button) {
    button.remove();
  }
}

// Check if we should show the button
function shouldShowButton() {
  const url = window.location.href;

  // Don't show on extension pages or sensitive pages
  if (url.startsWith('chrome://') ||
      url.startsWith('chrome-extension://') ||
      url.startsWith('https://accounts.google.com') ||
      url.startsWith('https://www.facebook.com')) {
    return false;
  }

  return true;
}

// Initialize
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    if (shouldShowButton()) {
      injectSaveButton();
    }
  });
} else {
  if (shouldShowButton()) {
    injectSaveButton();
  }
}

// Listen for messages from background script
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'toggleButton') {
    if (request.show) {
      injectSaveButton();
    } else {
      removeSaveButton();
    }
  }

  if (request.action === 'getPageInfo') {
    sendResponse({
      url: window.location.href,
      title: document.title,
      selection: window.getSelection().toString()
    });
  }
});

// Clean up on page unload
window.addEventListener('beforeunload', () => {
  removeSaveButton();
});
