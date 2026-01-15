// Background service worker for L2L extension

// Install event
chrome.runtime.onInstalled.addListener((details) => {
  if (details.reason === 'install') {
    console.log('L2L extension installed');

    // Open welcome page
    chrome.tabs.create({
      url: 'https://l2l.com/welcome'
    });
  } else if (details.reason === 'update') {
    console.log('L2L extension updated');
  }
});

// Handle messages from content scripts
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'savePage') {
    handleSavePage(request.data, sender.tab)
      .then(sendResponse)
      .catch(error => sendResponse({ success: false, error: error.message }));
    return true; // Keep message channel open for async response
  }

  if (request.action === 'checkAuth') {
    checkAuth()
      .then(sendResponse)
      .catch(error => sendResponse({ success: false, error: error.message }));
    return true;
  }
});

// Handle save page action
async function handleSavePage(pageData, tab) {
  try {
    // Get auth token
    const session = await chrome.storage.local.get(['token']);
    if (!session.token) {
      throw new Error('Not authenticated');
    }

    // Call API to save bookmark
    const response = await fetch('http://localhost:3000/api/v1/content/entities', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${session.token}`
      },
      body: JSON.stringify({
        url: pageData.url,
        projectId: pageData.projectId,
        tags: pageData.tags || [],
        notes: pageData.notes || ''
      })
    });

    const data = await response.json();

    if (data.success) {
      // Show notification
      chrome.notifications.create({
        type: 'basic',
        iconUrl: 'assets/icon128.png',
        title: 'L2L - Saved!',
        message: 'Content saved to your library'
      });

      return { success: true, data: data.data };
    } else {
      throw new Error(data.message || 'Failed to save');
    }
  } catch (error) {
    console.error('Error saving page:', error);
    throw error;
  }
}

// Check authentication status
async function checkAuth() {
  const session = await chrome.storage.local.get(['user', 'token']);
  return {
    success: !!(session.user && session.token),
    user: session.user
  };
}

// Context menu (optional feature)
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: 'saveToL2L',
    title: 'Save to L2L',
    contexts: ['page', 'selection']
  });
});

chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === 'saveToL2L') {
    // Open popup
    chrome.action.openPopup();
  }
});

// Keep service worker alive
setInterval(() => {
  chrome.runtime.getPlatformInfo(() => {});
}, 60000); // Every minute
