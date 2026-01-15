# 🔧 Docker Desktop Installation - Manual Setup

## ⚠️ Installation Failed

The automatic Docker installation via Homebrew encountered an issue. Please use one of the manual installation methods below.

## 📥 Installation Options

### Option 1: Direct Download (Recommended - Fastest)

1. **Download Docker Desktop for Mac**:
   - Visit: https://www.docker.com/products/docker-desktop/
   - Click "Download for Mac"
   - Choose **Apple Silicon** (for M1/M2/M3) or **Intel Chip** based on your Mac

2. **Install**:
   - Open the downloaded `Docker.dmg` file
   - Drag Docker icon to Applications folder
   - Eject the DMG when complete

3. **Launch Docker Desktop**:
   - Open Applications folder
   - Double-click Docker.app
   - Complete the setup wizard
   - Wait for Docker to start (Docker icon appears in menu bar)

### Option 2: Homebrew (Retry)

```bash
# Update Homebrew first
brew update

# Try installing again
brew install --cask docker

# Or install the latest version directly
brew install --cask docker-desktop
```

### Option 3: Use Colima (Lightweight Alternative)

If Docker Desktop has issues, try **Colima** - a lightweight Docker alternative for Mac:

```bash
# Install Colima and Docker CLI
brew install docker colima

# Start Colima
colima start

# Verify
docker info
```

## ✅ Verify Installation

After installing, verify Docker is working:

```bash
# Check Docker version
docker --version

# Check Docker is running
docker info

# Test with hello-world
docker run hello-world
```

Expected output:
```
Docker version 24.0.x or higher
Hello from Docker!
```

## 🚀 Start L2L Development Environment

Once Docker is installed and running:

```bash
cd /Users/bs0650/R&D/AI/L2L

# Start everything
./start-dev.sh

# Or manually
docker-compose -f docker-compose.dev.yml up -d
```

## 🔧 Troubleshooting

### Issue: "Docker Desktop won't start"

**Solution**:
```bash
# Check system requirements
# Docker Desktop requires macOS 11 or later (Big Sur)

# Try restarting Docker Desktop
killall Docker
sleep 5
open -a Docker

# Check Docker logs
~/Library/Containers/com.docker.docker/Data/log/host
```

### Issue: "Permission denied"

**Solution**:
```bash
# Fix Docker permissions
sudo chown -R $USER /var/run/docker.sock

# Or add your user to docker group (Linux)
sudo usermod -aG docker $USER
```

### Issue: "Port 3000 already in use"

**Solution**:
```bash
# Check what's using the port
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or change ports in docker-compose.dev.yml
```

### Issue: "Docker command not found"

**Solution**:
```bash
# Add Docker to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="/opt/homebrew/bin:$PATH"

# Reload shell
source ~/.zshrc
```

## 🎯 Quick Start After Installation

1. **Install Docker Desktop** (use Option 1 above)
2. **Launch Docker Desktop** from Applications
3. **Wait for Docker to start** (Docker icon in menu bar)
4. **Start L2L**:
   ```bash
   cd /Users/bs0650/R&D/AI/L2L
   ./start-dev.sh
   ```

## 📚 Alternative: Use Colima (Recommended if Docker Desktop fails)

If Docker Desktop continues to have issues:

```bash
# Install Colima (Container Linux on Mac)
brew install docker colima

# Start Colima with default configuration
colima start

# Verify Docker is working
docker run hello-world

# Start L2L (should work with Colima)
cd /Users/bs0650/R&D/AI/L2L
docker-compose -f docker-compose.dev.yml up -d
```

Colima advantages:
- ✅ Lighter weight than Docker Desktop
- ✅ Faster startup
- ✅ Better resource management
- ✅ Full Docker compatibility

## 🆘 Still Having Issues?

1. Check macOS version (requires macOS 11+)
2. Check available disk space (needs 20GB+)
3. Check RAM (needs 4GB+ available)
4. Try Colima as an alternative

## 📋 System Requirements

- **macOS**: Big Sur (11.0) or later
- **RAM**: 4GB minimum, 8GB recommended
- **Disk**: 20GB free space
- **Architecture**: Apple Silicon (M1/M2/M3) or Intel

## 🎓 Next Steps

Once Docker is running:

1. ✅ Start development environment: `./start-dev.sh`
2. ✅ Test API: `curl http://localhost:3000/health`
3. ✅ Run Flutter app: `cd app && flutter run`
4. ✅ Load browser extension: Load unpacked in Chrome
5. ✅ Start building features!

---

**Recommendation**: Use **Option 1 (Direct Download)** for fastest and most reliable installation. If that fails, try **Colima** as a lightweight alternative.
