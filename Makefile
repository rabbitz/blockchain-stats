API_ERROR_PROTO_FILES=$(shell find api -name *.proto)

.PHONY: init
# init env
init:
	# install goctl
	GOPROXY=https://goproxy.cn/,direct go install github.com/zeromicro/go-zero/tools/goctl@latest
	goctl -v
	# install protoc & protoc-gen-go
	goctl env check -i -f --verbose
	# install protoc-gen-go-errors
	go get -u github.com/go-kratos/kratos/cmd/protoc-gen-go-errors/v2
	go install github.com/go-kratos/kratos/cmd/protoc-gen-go-errors/v2
	# clean
	go mod tidy
.PHONY: api
# generate api related files
api:

ifeq ($(origin API_FILE), undefined)
	$(error "please enter API_FILE")
endif

ifeq ($(origin SVC_NAME), undefined)
	$(error "please enter SVC_NAME")
endif
	goctl api go -api $(API_FILE) -dir 'app/$(SVC_NAME)' --style=goZero --home 'deploy/goctl/1.6.6'

.PHONY: model
# generate model related files
model:
ifeq ($(origin MODEL_SQL_FILE), undefined)
	$(error "please enter MODEL_FILE")
endif
	goctl model mysql ddl -src=${MODEL_SQL_FILE} -dir="app/ckb/model" -c --home=deploy/goctl

.PHONY: errors
# generate errors code
errors:
	protoc --proto_path=. \
             --proto_path=./third_party \
             --go_out=paths=source_relative:. \
             --go-errors_out=paths=source_relative:. \
             $(API_ERROR_PROTO_FILES)

.PHONY: lint
# lint code
lint:
	golangci-lint run ./...
