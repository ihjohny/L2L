# L2L Database CLI Guide

A command-line utility script for interacting with the MongoDB database used by the L2L application.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Available Commands](#available-commands)
- [Common Use Cases](#common-use-cases)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

- MongoDB Docker container must be running (`l2l-mongodb-dev`)
- Docker installed and accessible
- Bash shell environment

**Start MongoDB if not running:**
```bash
docker-compose -f docker-compose.dev.yml up -d mongodb
```

---

## Quick Start

```bash
# Make the script executable (first time only)
chmod +x db-cli.sh

# Show all available commands
./db-cli.sh help

# View all users
./db-cli.sh users

# Count total users
./db-cli.sh users-count
```

---

## Available Commands

### User Management

| Command | Description | Example |
|---------|-------------|---------|
| `users` | Display all users (excludes sensitive data) | `./db-cli.sh users` |
| `users-count` | Count total number of users | `./db-cli.sh users-count` |
| `user-email <email>` | Find a specific user by email address | `./db-cli.sh user-email "user@example.com"` |
| `user-username <name>` | Find a specific user by username | `./db-cli.sh user-username "johndoe"` |
| `user-id <id>` | Find a specific user by MongoDB ObjectId | `./db-cli.sh user-id "507f1f77bcf86cd799439011"` |
| `delete-user <email>` | Delete a user by email (with confirmation) | `./db-cli.sh delete-user "user@example.com"` |
| `export-users <file>` | Export all users to a JSON file | `./db-cli.sh export-users users.json` |

### Data Viewing

| Command | Description | Example |
|---------|-------------|---------|
| `projects` | Display all projects in the database | `./db-cli.sh projects` |
| `entities` | Display all entities in the database | `./db-cli.sh entities` |
| `collections` | List all collections in the database | `./db-cli.sh collections` |
| `stats` | Show database statistics and document counts | `./db-cli.sh stats` |

### Database Operations

| Command | Description | Example |
|---------|-------------|---------|
| `shell` | Open an interactive MongoDB shell | `./db-cli.sh shell` |
| `reset-db` | Drop the entire database (destructive!) | `./db-cli.sh reset-db` |

---

## Common Use Cases

### 1. Viewing Signup User Data

View all users who have signed up:
```bash
./db-cli.sh users
```

This displays:
- User ID, email, username
- Profile information (name, preferences)
- Subscription details (tier, dates)
- Statistics (bookmarks, completed projects, points)
- Verification status and timestamps

**Note:** Passwords and refresh tokens are automatically excluded for security.

### 2. Finding a Specific User

By email:
```bash
./db-cli.sh user-email "imam@gmail.com"
```

By username:
```bash
./db-cli.sh user-username "imam_hossain"
```

### 3. Checking Database Health

View overall statistics:
```bash
./db-cli.sh stats
```

Output example:
```
Database: l2l_dev
Collections: 3

  users: 1 documents
  projects: 0 documents
  entities: 0 documents
```

### 4. Exporting Data for Analysis

Export all users to a JSON file:
```bash
./db-cli.sh export-users backup/users-$(date +%Y%m%d).json
```

### 5. Interactive Database Operations

Open a MongoDB shell for complex queries:
```bash
./db-cli.sh shell
```

Once in the shell, you can run any MongoDB query:
```javascript
// Find users created in the last 24 hours
db.users.find({
  createdAt: { $gte: new Date(Date.now() - 24*60*60*1000) }
})

// Find all premium users
db.users.find({ 'subscription.tier': 'premium' })

// Count verified users
db.users.countDocuments({ isEmailVerified: true })

// Update user preferences
db.users.updateOne(
  { email: 'user@example.com' },
  { $set: { 'profile.preferences.theme': 'dark' } }
)
```

---

## Examples

### View Recently Registered Users

```bash
# First, open the shell
./db-cli.sh shell

# Then run this query in the MongoDB shell
db.users.find({}, {password: 0, refreshToken: 0}).sort({createdAt: -1}).limit(10)
```

### Count Users by Subscription Tier

```bash
./db-cli.sh shell
```

```javascript
db.users.aggregate([
  { $group: { _id: '$subscription.tier', count: { $sum: 1 } } }
])
```

### Find Unverified Users

```bash
./db-cli.sh shell
```

```javascript
db.users.find({ isEmailVerified: false }, {password: 0, refreshToken: 0})
```

### View User Activity Statistics

```bash
./db-cli.sh shell
```

```javascript
db.users.find({}, {
  email: 1,
  username: 1,
  'stats.totalPoints': 1,
  'stats.projectsCompleted': 1,
  'stats.streakDays': 1,
  lastLoginAt: 1
}).sort({ 'stats.totalPoints': -1 })
```

---

## Troubleshooting

### "MongoDB container is not running"

**Error:**
```
❌ Error: MongoDB container 'l2l-mongodb-dev' is not running
```

**Solution:**
```bash
# Check container status
docker ps -a | grep mongodb

# Start the container
docker-compose -f docker-compose.dev.yml up -d mongodb

# Or start it manually
docker start l2l-mongodb-dev
```

### "Permission denied" when running script

**Solution:**
```bash
chmod +x db-cli.sh
```

### Query returns nothing

- Verify you're connected to the correct database: `l2l_dev`
- Check if data exists: `./db-cli.sh stats`
- Try the interactive shell: `./db-cli.sh shell`

### MongoDB connection issues

```bash
# Check if MongoDB is responding
docker exec l2l-mongodb-dev mongosh --eval "db.adminCommand('ping')"

# Check container logs
docker logs l2l-mongodb-dev

# Restart MongoDB
docker-compose -f docker-compose.dev.yml restart mongodb
```

---

## Security Notes

⚠️ **Important Security Information:**

1. **Passwords are hidden** by default from all query outputs
2. **Refresh tokens** are excluded from exports and displays
3. The `delete-user` and `reset-db` commands require explicit confirmation
4. Always use production MongoDB authentication in production environments
5. Be cautious when exporting user data - ensure JSON files are securely stored

---

## Database Schema Reference

### Users Collection Structure

```javascript
{
  _id: ObjectId("..."),
  email: "user@example.com",
  username: "johndoe",
  password: "hashed_password",  // Hidden by default
  profile: {
    firstName: "John",
    lastName: "Doe",
    avatar: "optional-url",
    bio: "Optional bio text",
    preferences: {
      theme: "light|dark|system",
      language: "en",
      notifications: { email, push, marketing, learningReminders, socialUpdates },
      privacy: { profileVisibility, activityVisibility, showProgress }
    }
  },
  subscription: {
    tier: "free|premium|enterprise",
    startDate: ISODate("..."),
    endDate: ISODate("..."),  // Optional
    stripeCustomerId: "...",  // Optional
    stripeSubscriptionId: "...",  // Optional
    cancelAtPeriodEnd: false
  },
  stats: {
    totalBookmarks: 0,
    projectsCompleted: 0,
    streakDays: 0,
    totalPoints: 0,
    currentLevel: 1,
    quizzesCompleted: 0,
    flashcardsReviewed: 0
  },
  isEmailVerified: false,
  lastLoginAt: ISODate("..."),
  refreshToken: "...",  // Hidden by default
  createdAt: ISODate("..."),
  updatedAt: ISODate("...")
}
```

---

## Additional Resources

- [MongoDB Shell Documentation](https://www.mongodb.com/docs/manual/mongo/)
- [L2L Technical Specification](../docs/technical_specification.md)
- [Getting Started Guide](../GETTING_STARTED.md)

---

## Tips & Tricks

### Creating Aliases (Optional)

Add these to your `~/.bashrc` or `~/.zshrc`:

```bash
# L2L Database aliases
alias l2ldb='./db-cli.sh'
alias l2lusers='./db-cli.sh users'
alias l2lstats='./db-cli.sh stats'
alias l2lshell='./db-cli.sh shell'
```

### Quick User Search

Create a simple grep filter for users:
```bash
./db-cli.sh users | grep -i "search_term"
```

### Backup Entire Database

```bash
# Export all collections
docker exec l2l-mongodb-dev mongodump --db=l2l_dev --archive=/tmp/l2l_backup.archive
docker cp l2l-mongodb-dev:/tmp/l2l_backup.archive ./backup/
```

---

## Version History

- **v1.0** - Initial release with basic user management and data viewing commands
