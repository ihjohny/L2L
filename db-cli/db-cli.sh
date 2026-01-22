#!/bin/bash

# L2L MongoDB Database CLI Utility
# Usage: ./db-cli.sh [command] [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# MongoDB container name
DB_CONTAINER="l2l-mongodb-dev"
DB_NAME="l2l_dev"

# Check if MongoDB container is running
check_db() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${DB_CONTAINER}$"; then
        echo -e "${RED}❌ Error: MongoDB container '${DB_CONTAINER}' is not running${NC}"
        echo "Start it with: docker-compose -f docker-compose.dev.yml up -d mongodb"
        exit 1
    fi
}

# Execute mongosh command
exec_mongosh() {
    check_db
    docker exec ${DB_CONTAINER} mongosh ${DB_NAME} --eval "$1" --quiet 2>/dev/null || echo "Error executing query"
}

# Show help
show_help() {
    echo -e "${BLUE}L2L MongoDB Database CLI${NC}"
    echo ""
    echo "Usage: ./db-cli.sh [command] [options]"
    echo ""
    echo "Commands:"
    echo "  users                    Show all users (excluding sensitive data)"
    echo "  users-count              Count total users"
    echo "  user-email <email>       Find user by email"
    echo "  user-username <name>     Find user by username"
    echo "  user-id <id>             Find user by ID"
    echo "  topics                   Show all topics"
    echo "  projects                 Show all projects"
    echo "  entities                 Show all entities"
    echo "  collections              List all collections"
    echo "  stats                    Show database statistics"
    echo "  shell                    Open interactive MongoDB shell"
    echo "  export-users <file>      Export users to JSON file"
    echo "  delete-user <email>      Delete user by email (CAUTION!)"
    echo "  reset-db                 Drop entire database (CAUTION!)"
    echo "  help                     Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./db-cli.sh users"
    echo "  ./db-cli.sh user-email imam@gmail.com"
    echo "  ./db-cli.sh export-users users.json"
    echo "  ./db-cli.sh shell"
}

# Show all users
show_users() {
    echo -e "${BLUE}📋 All Users:${NC}"
    echo ""
    exec_mongosh "db.users.find({}, {password: 0, refreshToken: 0, __v: 0}).pretty()"
}

# Count users
count_users() {
    count=$(exec_mongosh "db.users.countDocuments()")
    echo -e "${GREEN}👥 Total Users: ${count}${NC}"
}

# Find user by email
find_user_email() {
    if [ -z "$1" ]; then
        echo -e "${RED}❌ Error: Email address required${NC}"
        echo "Usage: ./db-cli.sh user-email <email>"
        exit 1
    fi
    echo -e "${BLUE}🔍 User with email '$1':${NC}"
    echo ""
    exec_mongosh "db.users.findOne({email: '$1'}, {password: 0, refreshToken: 0, __v: 0})"
}

# Find user by username
find_user_username() {
    if [ -z "$1" ]; then
        echo -e "${RED}❌ Error: Username required${NC}"
        echo "Usage: ./db-cli.sh user-username <username>"
        exit 1
    fi
    echo -e "${BLUE}🔍 User with username '$1':${NC}"
    echo ""
    exec_mongosh "db.users.findOne({username: '$1'}, {password: 0, refreshToken: 0, __v: 0})"
}

# Find user by ID
find_user_id() {
    if [ -z "$1" ]; then
        echo -e "${RED}❌ Error: User ID required${NC}"
        echo "Usage: ./db-cli.sh user-id <id>"
        exit 1
    fi
    echo -e "${BLUE}🔍 User with ID '$1':${NC}"
    echo ""
    exec_mongosh "db.users.findOne({_id: ObjectId('$1')}, {password: 0, refreshToken: 0, __v: 0})"
}

# Show all topics
show_topics() {
    echo -e "${BLUE}📚 All Topics:${NC}"
    echo ""
    exec_mongosh "db.topics.find().pretty()"
}

# Show all projects
show_projects() {
    echo -e "${BLUE}🚀 All Projects:${NC}"
    echo ""
    exec_mongosh "db.projects.find().pretty()"
}

# Show all entities
show_entities() {
    echo -e "${BLUE}🧩 All Entities:${NC}"
    echo ""
    exec_mongosh "db.entities.find().pretty()"
}

# List all collections
show_collections() {
    echo -e "${BLUE}📁 Collections:${NC}"
    echo ""
    exec_mongosh "db.getCollectionNames().sort()"
}

# Show database statistics
show_stats() {
    echo -e "${BLUE}📊 Database Statistics:${NC}"
    echo ""
    exec_mongosh "
    print('Database: ' + db.getName());
    print('Collections: ' + db.getCollectionNames().length);
    print('');
    db.getCollectionNames().forEach(function(col) {
        var count = db[col].countDocuments();
        print('  ' + col + ': ' + count + ' documents');
    });
    "
}

# Open interactive shell
open_shell() {
    echo -e "${GREEN}🐚 Opening MongoDB shell...${NC}"
    echo -e "${YELLOW}Type 'exit' to quit${NC}"
    echo ""
    check_db
    docker exec -it ${DB_CONTAINER} mongosh ${DB_NAME}
}

# Export users to JSON file
export_users() {
    if [ -z "$1" ]; then
        echo -e "${RED}❌ Error: Output file required${NC}"
        echo "Usage: ./db-cli.sh export-users <output-file.json>"
        exit 1
    fi
    echo -e "${BLUE}💾 Exporting users to '$1'...${NC}"
    check_db
    docker exec ${DB_CONTAINER} mongosh ${DB_NAME} --eval "db.users.find({}, {password: 0, refreshToken: 0, __v: 0})" --quiet > "$1"
    echo -e "${GREEN}✅ Exported to $1${NC}"
}

# Delete user by email
delete_user() {
    if [ -z "$1" ]; then
        echo -e "${RED}❌ Error: Email address required${NC}"
        echo "Usage: ./db-cli.sh delete-user <email>"
        exit 1
    fi
    echo -e "${RED}⚠️  WARNING: This will delete user with email '$1'${NC}"
    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        exec_mongosh "db.users.deleteOne({email: '$1'})"
        echo -e "${GREEN}✅ User deleted${NC}"
    else
        echo "Aborted"
    fi
}

# Reset entire database
reset_db() {
    echo -e "${RED}⚠️  WARNING: This will drop the entire database '${DB_NAME}'${NC}"
    echo -e "${RED}All data will be lost!${NC}"
    read -p "Are you sure? Type 'DELETE' to confirm: " confirm
    if [ "$confirm" = "DELETE" ]; then
        exec_mongosh "db.dropDatabase()"
        echo -e "${GREEN}✅ Database dropped${NC}"
    else
        echo "Aborted"
    fi
}

# Main command dispatcher
case "$1" in
    users)
        show_users
        ;;
    users-count)
        count_users
        ;;
    user-email)
        find_user_email "$2"
        ;;
    user-username)
        find_user_username "$2"
        ;;
    user-id)
        find_user_id "$2"
        ;;
    topics)
        show_topics
        ;;
    projects)
        show_projects
        ;;
    entities)
        show_entities
        ;;
    collections)
        show_collections
        ;;
    stats)
        show_stats
        ;;
    shell)
        open_shell
        ;;
    export-users)
        export_users "$2"
        ;;
    delete-user)
        delete_user "$2"
        ;;
    reset-db)
        reset_db
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac
