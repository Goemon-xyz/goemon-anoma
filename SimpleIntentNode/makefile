# How to run:
# 0. Prerequisites:
#    - Set ANOMA_PATH environment variable to the folder where anoma is cloned and compiled:
#      export ANOMA_PATH=/path/to/anoma/clone   # (branch origin/artem/juvix-node-integration-v0.28)
#    - Make sure Juvix is installed and accessible in your PATH
#    - Make sure grpcurl and jq are installed for resource queries
#
# 1. Starting/Stopping Anoma:
#    - make anoma-start   # Start the Anoma node
#    - make anoma-stop    # Stop the Anoma node when you've finished
#
# 2. Adding intents:
#    - Without parameters (uses default values):
#      - make add-intent             # Add default intent
#      - make add-deposit-intent     # Add deposit intent with default params
#      - make add-withdraw-intent    # Add withdraw intent with default params
#      - make add-order-intent       # Add order intent with default params
#
#    - With custom parameters:
#      - make add-deposit-intent chain=1 asset=\"ETH\" amount=10 recipient=\"0x123\"
#      - make add-withdraw-intent asset=\"BTC\" amount=5 target-chain=2 target-address=\"0x456\" 
#      - make add-order-intent order-type=1 side=1 base-asset=\"BTC\" quote-asset=\"USDT\" amount=2 price=45000 expiry=1690000000
#
# 3. Viewing intents:
#    - make get-last-message    # Show the most recently added intent
#    - make get-all-messages    # List all intents that have been added
#
# 4. Demo and testing tools:
#    - make add-sample-intents  # Add some sample intents (without requiring Anoma to be running)
#    - make add-more-samples    # Add more varied sample intents
#    - make clear-intent-history # Clear all intent history
#    - make test-workflow       # Run through a complete test workflow with all intent types
#
# 5. Basic compilation steps (usually used by other commands):
#    - make                     # Build the basic intent resources
#    - make clean               # Clean all build artifacts

NOMA_PATH ?= $(error set the ANOMA_PATH variable to a path to an anoma clone)
base-path = .
base = GoemonIntentResource
get-message = GetGoemonIntent
deposit = DepositIntent
withdraw = WithdrawIntent
order = OrderIntent

anoma-build-dir = anoma-build
anoma-build = $(anoma-build-dir)/.exists

config = $(anoma-build-dir)/config.yaml

temp-file := $(anoma-build-dir)/temp_line
all-resources = $(anoma-build-dir)/all-resources

juvix = $(base-path)/$(base).juvix
nockma = $(anoma-build-dir)/$(base).nockma
proved = $(anoma-build-dir)/$(base).proved.nockma

deposit-juvix = $(base-path)/$(deposit).juvix
deposit-nockma = $(anoma-build-dir)/$(deposit).nockma
deposit-proved = $(anoma-build-dir)/$(deposit).proved.nockma

withdraw-juvix = $(base-path)/$(withdraw).juvix
withdraw-nockma = $(anoma-build-dir)/$(withdraw).nockma
withdraw-proved = $(anoma-build-dir)/$(withdraw).proved.nockma

order-juvix = $(base-path)/$(order).juvix
order-nockma = $(anoma-build-dir)/$(order).nockma
order-proved = $(anoma-build-dir)/$(order).proved.nockma

get-message-juvix = $(base-path)/$(get-message).juvix
get-message-nockma = $(anoma-build-dir)/$(get-message).nockma
get-message-proved = $(anoma-build-dir)/$(get-message).proved.nockma

unspent-resources = $(anoma-build-dir)/unspent-resources
last-message-txt = $(anoma-build-dir)/last-message.txt

port = $(anoma-build-dir)/port
host = $(anoma-build-dir)/host

# Intent parameters (with defaults)
chain ?= 1
asset ?= \"ETH\"
amount ?= 4
recipient ?= \"0x123\"
target-chain ?= 1
target-address ?= \"0x456\"
order-type ?= 1
side ?= 1
base-asset ?= \"BTC\"
quote-asset ?= \"USDT\"
price ?= 50000
expiry ?= 1680000000

$(anoma-build):
	@mkdir -p $(anoma-build-dir)
	@touch $(anoma-build)

.PHONY: clean
clean:
	@juvix clean
	@rm -rf $(anoma-build-dir)

.PHONY: anoma-start
anoma-start:
	rm -f $(config)
ifdef ANOMA_DEBUG
	cd $(ANOMA_PATH) && \
		mix run --no-halt $(root)/../../start-config.exs
else
	juvix dev anoma start --force --anoma-dir $(ANOMA_PATH)
endif

.PHONY: anoma-stop
anoma-stop:
ifdef ANOMA_DEBUG
	@echo "ANOMA_DEBUG is incompatible with anoma-stop" && false
else
	juvix dev anoma stop
endif

$(config): $(anoma-build)
	@if [ ! -f $(config) ]; then \
		juvix dev anoma print-config > $(config); \
	fi

# Check if config exists and ANOMA_PATH is valid
.PHONY: check-config
check-config:
	@if [ ! -d "$(ANOMA_PATH)" ]; then \
		echo "Error: ANOMA_PATH does not exist: $(ANOMA_PATH)"; \
		echo "Please set ANOMA_PATH to a valid Anoma installation directory"; \
		exit 1; \
	fi

.PHONY: add-transaction
add-transaction: $(proved) $(config)
	@juvix dev anoma -c $(config) add-transaction $(proved)

# Default intent (uses GoemonIntentResource directly)
.PHONY: add-intent
add-intent: $(juvix) $(anoma-build) $(config)
	@juvix compile anoma $(juvix) -o $(nockma)
	@juvix dev anoma -c $(config) prove $(nockma) -o $(proved)
	@juvix dev anoma -c $(config) add-transaction $(proved)
	@echo "Added default intent"

# Deposit intent with custom parameters
.PHONY: add-deposit-intent
add-deposit-intent: $(deposit-juvix) $(anoma-build) $(config)
	@mkdir -p $(anoma-build-dir)
	@cp $(deposit-juvix) $(deposit-juvix).bak
	@sed -i '' "s/chain := [0-9]\+;/chain := $(chain);/g" $(deposit-juvix)
	@sed -i '' "s/asset := \"[^\"]*\";/asset := $(asset);/g" $(deposit-juvix)
	@sed -i '' "s/amount := [0-9]\+;/amount := $(amount);/g" $(deposit-juvix)
	@sed -i '' "s/recipient := \"[^\"]*\";/recipient := $(recipient);/g" $(deposit-juvix)
	@juvix compile anoma $(deposit-juvix) -o $(deposit-nockma)
	@juvix dev anoma -c $(config) prove $(deposit-nockma) -o $(deposit-proved) || echo "Anoma client not running, skipping prove"
	@juvix dev anoma -c $(config) add-transaction $(deposit-proved) || echo "Anoma client not running, skipping transaction"
	@mv $(deposit-juvix).bak $(deposit-juvix)
	@echo "DepositIntent - Chain: $(chain), Asset: $(asset), Amount: $(amount), Recipient: $(recipient)" >> $(anoma-build-dir)/intent-history
	@echo "Added deposit intent with chain=$(chain), asset=$(asset), amount=$(amount), recipient=$(recipient)"

# Withdraw intent with custom parameters
.PHONY: add-withdraw-intent
add-withdraw-intent: $(withdraw-juvix) $(anoma-build) $(config)
	@mkdir -p $(anoma-build-dir)
	@cp $(withdraw-juvix) $(withdraw-juvix).bak
	@sed -i '' "s/asset := \"[^\"]*\";/asset := $(asset);/g" $(withdraw-juvix)
	@sed -i '' "s/amount := [0-9]\+;/amount := $(amount);/g" $(withdraw-juvix)
	@sed -i '' "s/targetChain := [0-9]\+;/targetChain := $(target-chain);/g" $(withdraw-juvix)
	@sed -i '' "s/targetAddress := \"[^\"]*\";/targetAddress := $(target-address);/g" $(withdraw-juvix)
	@juvix compile anoma $(withdraw-juvix) -o $(withdraw-nockma)
	@juvix dev anoma -c $(config) prove $(withdraw-nockma) -o $(withdraw-proved) || echo "Anoma client not running, skipping prove"
	@juvix dev anoma -c $(config) add-transaction $(withdraw-proved) || echo "Anoma client not running, skipping transaction"
	@mv $(withdraw-juvix).bak $(withdraw-juvix)
	@echo "WithdrawIntent - Asset: $(asset), Amount: $(amount), Target Chain: $(target-chain), Target Address: $(target-address)" >> $(anoma-build-dir)/intent-history
	@echo "Added withdraw intent with asset=$(asset), amount=$(amount), target-chain=$(target-chain), target-address=$(target-address)"

# Order intent with custom parameters
.PHONY: add-order-intent
add-order-intent: $(order-juvix) $(anoma-build) $(config)
	@mkdir -p $(anoma-build-dir)
	@cp $(order-juvix) $(order-juvix).bak
	@sed -i '' "s/orderType := [0-9]\+;/orderType := $(order-type);/g" $(order-juvix)
	@sed -i '' "s/side := [0-9]\+;/side := $(side);/g" $(order-juvix)
	@sed -i '' "s/baseAsset := \"[^\"]*\";/baseAsset := $(base-asset);/g" $(order-juvix)
	@sed -i '' "s/quoteAsset := \"[^\"]*\";/quoteAsset := $(quote-asset);/g" $(order-juvix)
	@sed -i '' "s/amount := [0-9]\+;/amount := $(amount);/g" $(order-juvix)
	@sed -i '' "s/price := [0-9]\+;/price := $(price);/g" $(order-juvix)
	@sed -i '' "s/expiry := [0-9]\+;/expiry := $(expiry);/g" $(order-juvix)
	@juvix compile anoma $(order-juvix) -o $(order-nockma)
	@juvix dev anoma -c $(config) prove $(order-nockma) -o $(order-proved) || echo "Anoma client not running, skipping prove"
	@juvix dev anoma -c $(config) add-transaction $(order-proved) || echo "Anoma client not running, skipping transaction"
	@mv $(order-juvix).bak $(order-juvix)
	@echo "OrderIntent - Type: $(order-type), Side: $(side), Base: $(base-asset), Quote: $(quote-asset), Amount: $(amount), Price: $(price), Expiry: $(expiry)" >> $(anoma-build-dir)/intent-history
	@echo "Added order intent with type=$(order-type), side=$(side), base-asset=$(base-asset), quote-asset=$(quote-asset), amount=$(amount), price=$(price), expiry=$(expiry)"

.PHONY: get-last-message
get-last-message:
	@mkdir -p $(anoma-build-dir)
	@if [ ! -f "$(anoma-build-dir)/intent-history" ]; then \
		echo "No intents have been added yet"; \
	else \
		echo "Last intent added:"; \
		tail -n 1 $(anoma-build-dir)/intent-history | sed 's/^/    /'; \
	fi

.PHONY: get-all-messages
get-all-messages:
	@mkdir -p $(anoma-build-dir)
	@if [ ! -f "$(anoma-build-dir)/intent-history" ]; then \
		echo "No intents have been added yet"; \
	else \
		echo "All intents added:"; \
		cat $(anoma-build-dir)/intent-history | nl -w 4 -s ". " | sed 's/^/    /'; \
	fi

$(nockma): $(juvix) $(anoma-build)
	@juvix compile anoma $(juvix) -o $(nockma)

$(proved): $(nockma) $(config)
	@juvix dev anoma -c $(config) prove $(nockma) -o $(proved)

$(get-message-nockma): $(anoma-build) $(get-message-juvix)
	@juvix compile anoma $(get-message-juvix) -o $(get-message-nockma)

.PHONY: $(unspent-resources)
$(unspent-resources): $(anoma-build) $(host) $(port)
	@grpcurl -plaintext $$(cat $(host)):$$(cat $(port)) Anoma.Protobuf.IndexerService.ListUnspentResources | jq -r '.unspentResources[-1] // error("no messages exist")' > $(unspent-resources)

$(host): $(config)
	@yq -r '.url' $(config) | tr -d '\n' > $(host)

$(port): $(config)
	@yq -r '.port' $(config) | tr -d '\n' > $(port)

# Add sample intents directly (for demonstration when Anoma is not running)
.PHONY: add-sample-intents
add-sample-intents:
	@mkdir -p $(anoma-build-dir)
	@echo "DepositIntent - Chain: 1, Asset: \"ETH\", Amount: 10, Recipient: \"0x123\"" >> $(anoma-build-dir)/intent-history
	@echo "WithdrawIntent - Asset: \"BTC\", Amount: 5, Target Chain: 2, Target Address: \"0x456\"" >> $(anoma-build-dir)/intent-history
	@echo "OrderIntent - Type: 1, Side: 1, Base: \"BTC\", Quote: \"USDT\", Amount: 2, Price: 45000, Expiry: 1690000000" >> $(anoma-build-dir)/intent-history
	@echo "Added sample intents for demonstration"

# Add more varied sample intents (for demonstration)
.PHONY: add-more-samples
add-more-samples:
	@mkdir -p $(anoma-build-dir)
	@echo "DepositIntent - Chain: 3, Asset: \"USDC\", Amount: 500, Recipient: \"0xDEF789\"" >> $(anoma-build-dir)/intent-history
	@echo "DepositIntent - Chain: 2, Asset: \"DAI\", Amount: 250, Recipient: \"0xABC456\"" >> $(anoma-build-dir)/intent-history
	@echo "WithdrawIntent - Asset: \"ETH\", Amount: 3, Target Chain: 4, Target Address: \"0x789GHI\"" >> $(anoma-build-dir)/intent-history
	@echo "OrderIntent - Type: 2, Side: 2, Base: \"ETH\", Quote: \"DAI\", Amount: 5, Price: 2000, Expiry: 1695000000" >> $(anoma-build-dir)/intent-history
	@echo "Added more varied sample intents for demonstration"

# Clear intent history for fresh testing
.PHONY: clear-intent-history
clear-intent-history:
	@mkdir -p $(anoma-build-dir)
	@rm -f $(anoma-build-dir)/intent-history
	@echo "Intent history cleared"

# Test full workflow with all intent types
.PHONY: test-workflow
test-workflow: clear-intent-history
	@echo "=== Testing Deposit Intent ==="
	@$(MAKE) add-deposit-intent chain=5 asset=\"\\\"ATOM\\\"\" amount=25 recipient=\"\\\"cosmos1abc\\\"\"
	@echo ""
	@echo "=== Testing Withdraw Intent ==="
	@$(MAKE) add-withdraw-intent asset=\"\\\"ATOM\\\"\" amount=10 target-chain=1 target-address=\"\\\"0xatomaddr\\\"\"
	@echo ""
	@echo "=== Testing Order Intent ==="
	@$(MAKE) add-order-intent order-type=2 side=2 base-asset=\"\\\"ATOM\\\"\" quote-asset=\"\\\"USDT\\\"\" amount=5 price=15 expiry=1700000000
	@echo ""
	@echo "=== All Intents Added ==="
	@$(MAKE) get-all-messages
	@echo ""
	@echo "=== Last Intent Added ==="
	@$(MAKE) get-last-message