// Background service worker for L2L extension

// API Configuration
const API_BASE_URL = 'http://localhost:3000/api';
const API_VERSION = 'v1';

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

  if (request.action === 'getProjects') {
    getProjects()
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

    // Call API to save link
    const response = await fetch(`${API_BASE_URL}/${API_VERSION}/links`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${session.token}`
      },
      body: JSON.stringify({
        url: pageData.url,
        tags: pageData.tags || [],
        projectId: pageData.projectId || null
      })
    });

    const data = await response.json();

    if (data.success || data.data) {
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

// Get user's projects
async function getProjects() {
  try {
    const session = await chrome.storage.local.get(['token']);
    if (!session.token) {
      throw new Error('Not authenticated');
    }

    const response = await fetch(`${API_BASE_URL}/${API_VERSION}/projects`, {
      headers: {
        'Authorization': `Bearer ${session.token}`
      }
    });

    const data = await response.json();
    return { success: true, projects: data.data || [] };
  } catch (error) {
    console.error('Error fetching projects:', error);
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
