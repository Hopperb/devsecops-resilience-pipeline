#!/bin/bash

# Define colors for clean terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}  STARTING AUTOMATED DEVSECOPS PIPELINE  ${NC}"
echo -e "${YELLOW}=========================================${NC}"

FAILED=0

# 1. RUN GITLEAKS (SECRETS)
echo -e "\n[1/3] Scanning for hardcoded secrets (GitLeaks)..."
gitleaks detect --source=. --verbose --no-git
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ FAIL: Hardcoded secrets detected!${NC}"
    FAILED=1
else
    echo -e "${GREEN}✅ PASS: No secrets found.${NC}"
fi

# 2. RUN SEMGREP (SAST)
echo -e "\n[2/3] Scanning source code architecture (Semgrep)..."
~/.local/bin/semgrep scan --config=auto .
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ FAIL: Security flaws found in code architecture!${NC}"
    FAILED=1
else
    echo -e "${GREEN}✅ PASS: Code architecture looks secure.${NC}"
fi

# 3. RUN NPM AUDIT (SCA)
echo -e "\n[3/3] Auditing open-source dependencies (NPM Audit)..."
npm audit --audit-level=high
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ FAIL: High or Critical vulnerabilities found in supply chain!${NC}"
    FAILED=1
else
    echo -e "${GREEN}✅ PASS: Dependencies are clean.${NC}"
fi

# PIPELINE EVALUATION
echo -e "\n${YELLOW}=========================================${NC}"
if [ $FAILED -eq 1 ]; then
    echo -e "${RED}🛑 PIPELINE FAILED: Fix security flaws before committing.${NC}"
    exit 1
else
    echo -e "${GREEN}🚀 PIPELINE PASSED: Code is secure and ready for deployment!${NC}"
    exit 0
fi
