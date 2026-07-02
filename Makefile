SHELL := /bin/bash
ROOT_DIR := $(CURDIR)

.PHONY: setup validate lint-yaml kustomize-build helm-lint diff check-secrets ci clean

TOOLS := github.com/evilmartians/lefthook@latest

# ── Setup ──────────────────────────────────────────────────────────────────

setup:
	$(info [setup] Installing lefthook...)
	go install $(TOOLS)
	lefthook install
	$(info [setup] Checking system tools...)
	@command -v yamllint >/dev/null 2>&1 || { echo "Install yamllint: brew install yamllint"; exit 1; }
	@command -v kustomize >/dev/null 2>&1 || { echo "Install kustomize: brew install kustomize"; exit 1; }
	@command -v helm >/dev/null 2>&1     || { echo "Install helm: brew install helm"; exit 1; }
	$(info [setup] All tools ready)

# ── Validation ─────────────────────────────────────────────────────────────

validate: lint-yaml kustomize-build helm-lint check-secrets

lint-yaml:
	$(info === YAML Lint ===)
	yamllint -s $(ROOT_DIR)

kustomize-build:
	$(info === Kustomize Build ===)
	kustomize build $(ROOT_DIR) > /dev/null

helm-lint:
	$(info === Helm Lint ===)
	@if [ -d "$(ROOT_DIR)/charts" ]; then \
		for chart in $(ROOT_DIR)/charts/*/; do \
			[ -d "$$chart" ] && helm lint "$$chart" --strict; \
		done; \
	else \
		echo "  No charts/ directory — skipping"; \
	fi

check-secrets:
	$(info === Secrets Scan ===)
	@! grep -rEin '(password|secret|token|api_key|private_key)[:=]' \
		--include='*.yaml' --include='*.yml' --include='*.json' \
		--include='*.toml' --include='*.sh' \
		$(ROOT_DIR) \
		--exclude-dir='.git' --exclude-dir='.github' 2>/dev/null; \
	true

diff:
	$(info === Kustomize Diff ===)
	kustomize build $(ROOT_DIR)

# ── CI (runs in GitHub Actions via lefthook) ───────────────────────────────

ci: setup validate

clean:
	$(info [clean] Remove lefthook hooks...)
	lefthook uninstall 2>/dev/null || true
