VERSION ?= latest
STAGING_NAME = 147889171041.dkr.ecr.us-east-1.amazonaws.com/groove-staging-emailengine-base
PRODUCTION_NAME = 147889171041.dkr.ecr.us-east-1.amazonaws.com/groove-production-emailengine-base

image-dev:
	docker build -t groovehq/emailengine:${VERSION} .
	which kind >> /dev/null && kind load docker-image groovehq/emailengine:${VERSION}; echo

image-staging:
	docker build --build-arg VERSION=$(VERSION) -t $(STAGING_NAME):$(VERSION) .

push-image-staging:
	aws ecr get-login-password | docker login --username AWS --password-stdin 147889171041.dkr.ecr.us-east-1.amazonaws.com
	docker push $(STAGING_NAME):$(VERSION)

image-production:
	docker build --build-arg VERSION=$(VERSION) -t $(PRODUCTION_NAME):$(VERSION) .

push-image-production:
	aws ecr get-login-password | docker login --username AWS --password-stdin 147889171041.dkr.ecr.us-east-1.amazonaws.com
	docker push $(PRODUCTION_NAME):$(VERSION)

image-all: image-dev image-staging image-production
	echo "All images for $(VERSION) rebuild"
