DOTNET=$(TOP)/dotnet.sh

ifeq ($(V),)
DOTNET_Q_ARGS=--nologo -v:q -consoleloggerparameters:NoSummary -bl
else
DOTNET_Q_ARGS=--nologo -bl
endif

CONFIG?=Release

WASM_DEFAULT_BUILD_ARGS?=/p:TargetArchitecture=wasm /p:TargetOS=wasi /p:Configuration=$(CONFIG)
WASMTIME_PROV_PATH=$(realpath $(TOP)/artifacts/obj/wasmtime/wasmtime)

all: publish

build:
	$(DOTNET) build $(DOTNET_Q_ARGS) $(WASM_DEFAULT_BUILD_ARGS) $(MSBUILD_ARGS) $(PROJECT_NAME)

publish:
	$(DOTNET) publish $(DOTNET_Q_ARGS) $(WASM_DEFAULT_BUILD_ARGS) -p:WasmBuildOnlyAfterPublish=true $(MSBUILD_ARGS) $(PROJECT_NAME)

clean:
	rm -rf bin $(TOP)/artifacts/obj/mono/$(PROJECT_NAME:%.csproj=%)

run-console:
	cd bin/wasi-wasm/AppBundle && $(WASMTIME_PROV_PATH) run $(PROJECT_NAME:.csproj=.wasm) $(ARGS)
