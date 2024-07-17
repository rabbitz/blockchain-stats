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
	goctl api go -api $(API_FILE) -dir 'app/$(SVC_NAME)' --style=goZero --home 'deploy/goctl/1.3.5'

.PHONY: model
# generate model related files
model:
ifeq ($(origin MODEL_SQL_FILE), undefined)
	$(error "please enter MODEL_FILE")
endif
	goctl model mysql ddl -src=${MODEL_SQL_FILE} -dir="app/datacenter/model" -c --home=deploy/goctl

.PHONY: errors
# generate errors code
errors:
	protoc --proto_path=. \
             --proto_path=./third_party \
             --go_out=paths=source_relative:. \
             --go-errors_out=paths=source_relative:. \
             $(API_ERROR_PROTO_FILES)

.PHONY: local-build
local-build:
	mkdir -p bin/ && go build -ldflags="-s -w" -o ./bin/ app/datacenter/datacenter.go

.PHONY: build
# docker-compose.yml build
build:
	docker-compose --env-file deploy/.env.local build

.PHONY: start
# docker-compose.yml up
start:
	docker-compose --env-file deploy/.env.local up

.PHONY: lint
# lint code
lint:
	golangci-lint run ./...

.PHONY: create-db
create-db:
	docker exec -it ${CONTAINER_NAME} mysql -u"$(MYSQL_USER)" -p"$(MYSQL_PASSWORD)" -e "CREATE DATABASE IF NOT EXISTS blockchain_stats"

.PHONY: create-test-db
create-test-db:
	docker exec -it ${CONTAINER_NAME} mysql -u"$(MYSQL_USER)" -p"$(MYSQL_PASSWORD)" -e "CREATE DATABASE IF NOT EXISTS blockchain_stats_test;"

.PHONY: import-stats-test-data
import-stats-test-data:
	docker exec -i ${CONTAINER_NAME} mysql -u"$(MYSQL_USER)" -p"$(MYSQL_PASSWORD)" blockchain_stats_test < "$(SQL_FILE_PATH)"

.PHONY: migrate-up
migrate-up:
	migrate -database "mysql://$(MYSQL_USER):$(MYSQL_PASSWORD)@tcp(localhost:23306)/blockchain_stats?charset=utf8mb4&parseTime=true&loc=Asia%2FShanghai&multiStatements=true" -path app/datacenter/db/migrations -verbose up

.PHONY: migrate-down
migrate-down:
	migrate -database "mysql://$(MYSQL_USER):$(MYSQL_PASSWORD)@tcp(localhost:23306)/blockchain_stats?charset=utf8mb4&parseTime=true&loc=Asia%2FShanghai&multiStatements=true" -path app/datacenter/db/migrations -verbose down $(STEP)

.PHONY: migrate-force
migrate-force:
	migrate -database "mysql://$(MYSQL_USER):$(MYSQL_PASSWORD)@tcp(localhost:23306)/blockchain_stats?charset=utf8mb4&parseTime=true&loc=Asia%2FShanghai&multiStatements=true" -path app/datacenter/db/migrations force $(VERSION)

.PHONY: api-doc
api-doc:
	rm -f deploy/doc/*.md;
	goctl api doc --dir api/datacenter/v1/ -o deploy/doc;
	find deploy/doc ! -name 'datacenter.md' -type f -exec rm -f {} +;
	goctl api plugin --plugin goctl-swagger="swagger --filename blockchain_stats.json --host api.datacenter.dev/ --basepath /" --api api/datacenter/v1/datacenter.api --dir deploy/doc
