
IMAGE_NAME = haasgz.hand-china.com:34950/openshift-contrib/gitbook-s2i

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
