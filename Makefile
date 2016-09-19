image:=umweltdk/wordpress
version:=4.6.1

.PHONY: build push default
default: build
build: build-latest
push: push-latest

build-latest:
	$(MAKE) build-$(version)
	docker tag $(image):$(version) $(image):latest
	docker tag $(image):$(version)-onbuild $(image):onbuild
	docker tag $(image):$(version)-onbuild-bower $(image):onbuild-bower

build-%:
	docker build -t $(image):$* .
	docker build -t $(image):$*-onbuild -f Dockerfile.onbuild .
	docker build -t $(image):$*-onbuild-bower -f Dockerfile.onbuild-bower .

push-latest:
	$(MAKE) real-push-latest
	$(MAKE) push-$(version)

push-%:
	$(MAKE) real-push-$*

real-push-%:
	docker push $(image):$*
	docker push $(image):$(if $(subst latest,,$*),$*-,)onbuild
	docker push $(image):$(if $(subst latest,,$*),$*-,)onbuild-bower
