IMAGE_NAME ?= solana_image
CONTAINER_NAME ?= solana
DART_VERSION ?= stable

build:
	docker build -t ${IMAGE_NAME} --build-arg DART_VERSION=${DART_VERSION} .
run:
	docker-compose up -d
kill:
	docker kill ${CONTAINER_NAME}
	docker rm -f ${CONTAINER_NAME}
	docker rmi -f ${IMAGE_NAME}
