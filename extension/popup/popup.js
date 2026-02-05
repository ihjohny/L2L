// Configuration
const API_BASE_URL = 'http://localhost:3000/api/v1';

// State
let currentUser = null;
let authToken = null;
let currentTab = null;

// DOM Elements
const views = {
  login: document.getElementById('loginView'),
  save: document.getElementById('saveView'),
  loading: document.getElementById('loadingView'),
  success: document.getElementById('successView')
};

// Initialize
async function init() {
  // Load user session
  const session = await chrome.storage.local.get(['user', 'token']);
  currentUser = session.user;
  authToken = session.token;

  // Get current tab
  const tabs = await chrome.tabs.query({ active: true, currentWindow: true });
  currentTab = tabs[0];

  // Update UI based on auth state
  updateUI();

  // Setup event listeners
  setupEventListeners();

  // Load page info if authenticated
  if (currentUser && authToken) {
    loadPageInfo();
  }
}

function updateUI() {
  const loginView = views.login;
  const saveView = views.save;
  const logoutBtn = document.getElementById('logoutBtn');
  const userInfo = document.getElementById('userInfo');
  const statusBadge = document.getElementById('statusBadge');

  if (currentUser && authToken) {
    // Show save view
    loginView.classList.add('hidden');
    saveView.classList.remove('hidden');
    logoutBtn.classList.remove('hidden');

    // Update user info
    userInfo.querySelector('.username').textContent = currentUser.username;

    // Update status badge
    statusBadge.querySelector('.status-text').textContent = 'Connected';
    statusBadge.querySelector('.status-dot').style.background = '#34c759';
  } else {
    // Show login view
    loginView.classList.remove('hidden');
    saveView.classList.add('hidden');
    logoutBtn.classList.add('hidden');

    // Update user info
    userInfo.querySelector('.username').textContent = 'Not logged in';

    // Update status badge
    statusBadge.querySelector('.status-text').textContent = 'Not connected';
    statusBadge.querySelector('.status-dot').style.background = '#8e8e93';
  }
}

async function loadPageInfo() {
  if (!currentTab) return;

  document.getElementById('pageTitle').textContent = currentTab.title || 'Loading...';
  document.getElementById('pageUrl').textContent = currentTab.url || '';

  // Determine page icon based on URL
  const pageIcon = document.getElementById('pageIcon');
  if (currentTab.url.includes('youtube.com')) {
    pageIcon.textContent = '🎥';
  } else if (currentTab.url.includes('pdf')) {
    pageIcon.textContent = '📄';
  } else if (currentTab.url.includes('soundcloud') || currentTab.url.includes('spotify')) {
    pageIcon.textContent = '🎵';
  } else {
    pageIcon.textContent = '📚';
  }
}

function showView(viewName) {
  Object.values(views).forEach(view => view.classList.add('hidden'));
  views[viewName].classList.remove('hidden');
}

function setupEventListeners() {
  // Login form
  document.getElementById('loginForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    await handleLogin();
  });

  // Save form
  document.getElementById('saveForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    await handleSave();
  });

  // Logout
  document.getElementById('logoutBtn').addEventListener('click', async () => {
    await handleLogout();
  });

  // Open dashboard
  document.getElementById('openDashboard').addEventListener('click', () => {
    chrome.tabs.create({ url: 'http://localhost:3000' });
  });

  // Save another
  document.getElementById('saveAnother').addEventListener('click', () => {
    showView('save');
  });
}

async function handleLogin() {
  const email = document.getElementById('loginEmail').value;
  const password = document.getElementById('loginPassword').value;

  showView('loading');
  document.getElementById('loadingMessage').textContent = 'Signing in...';

  try {
    const response = await fetch(`${API_BASE_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email, password })
    });

    const data = await response.json();

    if (data.success) {
      // Save session
      await chrome.storage.local.set({
        user: data.data.user,
        token: data.data.token
      });

      currentUser = data.data.user;
      authToken = data.data.token;

      updateUI();
      await loadPageInfo();
    } else {
      showView('login');
      alert('Login failed: ' + (data.message || 'Unknown error'));
    }
  } catch (error) {
    showView('login');
    alert('Login failed: ' + error.message);
  }
}

async function handleSave() {
  const tags = document.getElementById('tagsInput').value;
  const notes = document.getElementById('notesInput').value;

  showView('loading');
  document.getElementById('loadingMessage').textContent = 'Saving to L2L...';

  try {
    const response = await fetch(`${API_BASE_URL}/content/entities`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${authToken}`
      },
      body: JSON.stringify({
        url: currentTab.url,
        tags: tags ? tags.split(',').map(t => t.trim()) : [],
        notes: notes
      })
    });

    const data = await response.json();

    if (data.success) {
      showView('success');

      // Show notification
      chrome.notifications.create({
        type: 'basic',
        iconUrl: 'assets/icon128.png',
        title: 'L2L - Saved!',
        message: 'Content saved to your library'
      });
    } else {
      showView('save');
      alert('Failed to save: ' + (data.message || 'Unknown error'));
    }
  } catch (error) {
    showView('save');
    alert('Failed to save: ' + error.message);
  }
}

async function handleLogout() {
  await chrome.storage.local.remove(['user', 'token']);
  currentUser = null;
  authToken = null;
  updateUI();
}

// Initialize on load
init();
