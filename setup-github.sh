#!/bin/bash

# GitHub Setup Script for Todo App CI/CD
# This script helps you set up the GitHub repository and secrets

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 GitHub CI/CD Setup for Todo App${NC}"
echo "=================================="

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Git repository not initialized. Initializing...${NC}"
    git init
    git add .
    git commit -m "Initial commit: Todo app with CI/CD pipeline"
fi

# Check if remote origin exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  No remote origin found.${NC}"
    echo "Please add your GitHub repository as origin:"
    echo "git remote add origin https://github.com/kamalkharel2002/todo.git"
    echo ""
fi

echo -e "${GREEN}✅ Files ready for GitHub:${NC}"
echo "  - .github/workflows/ci-cd.yml"
echo "  - tests/ (Jest test suite)"
echo "  - docker-compose.yml (with health checks)"
echo "  - Dockerfile.dev files"
echo ""

echo -e "${YELLOW}📋 Next Steps:${NC}"
echo ""
echo "1. Push to GitHub:"
echo "   git add ."
echo "   git commit -m 'Add CI/CD pipeline and tests'"
echo "   git push -u origin main"
echo ""
echo "2. Add GitHub Secrets (Settings → Secrets and variables → Actions):"
echo "   - DOCKER_USERNAME: kamal2411"
echo "   - DOCKER_PASSWORD: [Your Docker Hub Access Token]"
echo ""
echo "3. Verify CI/CD:"
echo "   - Go to Actions tab in your GitHub repo"
echo "   - Watch the CI pipeline run"
echo "   - Check Docker Hub for pushed images after main branch push"
echo ""
echo -e "${GREEN}🎉 Setup complete! Your CI/CD pipeline is ready.${NC}"