# Proxmox Preflight Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a manual, read-only GitHub Actions preflight that proves the Proxmox API can be reached with verified TLS before any provisioning run.

**Architecture:** A self-hosted runner on the lab network reads the endpoint, API token and local CA path from a protected local file outside the checkout. No GitHub Actions Secrets or Variables are used. It calls only read-only API endpoints and removes its temporary curl configuration when the job ends.

**Tech Stack:** GitHub Actions, Bash, curl, jq.

**Spec:** `docs/security.md`

## Global Constraints

- Do not commit credentials, private keys, certificates, API tokens, state files, or `.tfvars` files.
- Keep TLS verification enabled; use the local cluster CA and the DNS name covered by the certificate.
- Run only on a self-hosted Linux runner labeled `proxmox-lab`, with private-network reachability to the Proxmox API.
- The workflow must be manually triggered and must not change Proxmox resources.
- The local contract file and CA must be outside the checkout with permission `0600`; do not print the endpoint, authorization header or secret values.

## Review Focus

- Missing local token, CA or URL must stop before any API call.
- A certificate-chain or hostname error must fail the job instead of falling back to insecure TLS.
- A rejected token must fail without printing the response body or authorization value.
- The workflow must only query API endpoints and not send POST, PUT, or DELETE requests.
- The CA file must be removed even when the API check fails.

---

### Task 1: Add the security-contract test

**Files:**
- Create: `tests/proxmox-preflight-contract.sh`
- Test: `tests/proxmox-preflight-contract.sh`

**Interfaces:**
- Consumes: `.github/workflows/proxmox-preflight.yml`
- Produces: a non-zero exit status when the workflow omits the required security contract.

- [ ] **Step 1: Write the failing test**

Assert that the workflow is manual-only, uses the three required configuration references, uses `--cacert`, and contains no `-k`/`--insecure` option.

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/proxmox-preflight-contract.sh`

Expected: failure because the workflow does not exist yet.

### Task 2: Add the read-only preflight workflow

**Files:**
- Create: `.github/workflows/proxmox-preflight.yml`
- Test: `tests/proxmox-preflight-contract.sh`

**Interfaces:**
- Consumes: the local protected contract `/etc/proxmox-lab/preflight.env`, containing URL, token and CA-path values managed outside GitHub.
- Produces: a job summary with Proxmox version and node status, or a non-zero result without exposing secrets.

- [ ] **Step 1: Implement the manual workflow**

Use only GET requests to `/api2/json/version` and `/api2/json/nodes`. Require the three local configuration values and `0600` permissions before curl runs, pass the authorization header through a temporary curl configuration, and remove temporary files via a shell trap.

- [ ] **Step 2: Run the contract test**

Run: `bash tests/proxmox-preflight-contract.sh`

Expected: `PASS`.

- [ ] **Step 3: Validate workflow syntax and repository checks**

Run: `git diff --check` and `bash tests/proxmox-preflight-contract.sh`

Expected: both commands succeed.
