# 🛡️ DevSecOps Resilience Pipeline

A comprehensive DevSecOps laboratory demonstrating the integration of automated security gates (SAST, SCA, Secret Scanning) and dynamic functional testing (DAST) within a CI/CD pipeline. 

This project features a TypeScript Express API that was intentionally built with critical security flaws to validate the effectiveness of the automated security architecture.

## 🏗️ Architecture & Toolchain

| Category | Tool | Purpose |
|---|---|---|
| **API Backend** | Node.js / Express (TypeScript) | Target application handling HTTP requests |
| **Secret Scanning** | GitLeaks | Detects hardcoded credentials before they reach production |
| **SAST** | Semgrep | Static Analysis to catch vulnerable code patterns (e.g., injections) |
| **SCA** | NPM Audit | Supply Chain Analysis for third-party dependency vulnerabilities |
| **DAST / E2E** | Playwright | Dynamic runtime security and functional regression testing |
| **CI/CD** | GitHub Actions | Automated pipeline orchestration on push/pull requests |

---

## 🚨 Security Findings & Remediation

The initial iteration of this API contained three distinct vulnerabilities, all successfully caught and blocked by the automated pipeline:

### 1. Hardcoded Cloud Credentials
* **Vulnerability:** A production AWS API key was hardcoded directly into `index.ts`.
* **Detection:** Caught statically by the **GitLeaks** GitHub Action (Pipeline Exit Code 1).
* **Remediation:** Extracted the credential from the codebase and replaced it with a dynamic environment variable (`process.env.AWS_PROD_KEY`).

### 2. Arbitrary Code Execution (RCE)
* **Vulnerability:** The `/api/calculate` endpoint evaluated raw user input using the highly dangerous JavaScript `eval()` function.
* **Detection:** 
  * *Static:* **Semgrep** identified the dangerous sink and failed the build.
  * *Dynamic:* **Playwright** injected the `process.env` payload during runtime, confirming the API returned a `200 OK` with sensitive server variables.
* **Remediation:** Removed `eval()` entirely. Implemented a strict Regular Expression (`/^(\d+)([\+\-\*\/])(\d+)$/`) to parse and mathematically compute only valid integers and basic operators.

### 3. Documentation Secrets
* **Vulnerability:** Example documentation contained a dummy enterprise configuration string that mimicked a real hash.
* **Detection:** Caught by **GitLeaks** scanning the Markdown files.
* **Remediation:** Replaced the dummy hash with a generic `ENTERPRISE_KEY=your_key_here` placeholder to comply with secret scanning entropy rules.

---

## 🚀 Local Setup & Testing

**1. Install Dependencies**
```bash
npm install

