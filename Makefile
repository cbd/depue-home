BRIDGE_URL ?= http://100.66.211.57:6061/chat
BRIDGE_DEBUG_URL ?= http://100.66.211.57:6061/claude-debug-channel
BRIDGE_SOURCE ?= claude-laptop

.PHONY: help bridge-chat bridge-debug

help:
	@echo "Targets:"
	@echo "  make bridge-chat q='your question'"
	@echo "  make bridge-debug q='debug message'"
	@echo "Env: BRIDGE_TOKEN (required), BRIDGE_SOURCE (optional)"

bridge-chat:
	@if [ -z "$$BRIDGE_TOKEN" ]; then echo "error: set BRIDGE_TOKEN"; exit 1; fi
	@if [ -z "$(q)" ]; then echo "error: pass q='message'"; exit 1; fi
	@BRIDGE_URL="$(BRIDGE_URL)" BRIDGE_SOURCE="$(BRIDGE_SOURCE)" BRIDGE_TOKEN="$$BRIDGE_TOKEN" ./scripts/bridge-chat.sh "$(q)"

bridge-debug:
	@if [ -z "$$BRIDGE_TOKEN" ]; then echo "error: set BRIDGE_TOKEN"; exit 1; fi
	@if [ -z "$(q)" ]; then echo "error: pass q='message'"; exit 1; fi
	@BRIDGE_SOURCE="$(BRIDGE_SOURCE)-debug" BRIDGE_TOKEN="$$BRIDGE_TOKEN" ./scripts/bridge-debug.sh "$(q)"
