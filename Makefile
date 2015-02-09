NAME = konsti/passenger
PASSENGER_VERSION = 0.9.15
VERSION = 1.2.0

.PHONY: all build_all \
				build_ruby21 build_ruby22 build_full \
				tag_latest release clean clean_images

all: build_all

build_all: \
	build_ruby21 \
	build_ruby22 \
	build_full

build_ruby21:
	rm -rf ruby21_image
	cp -pR image ruby21_image
	sed -i 's/BASE_IMAGE/passenger-ruby21/' ruby21_image/Dockerfile
	sed -i "s/VERSION/$(PASSENGER_VERSION)/" ruby21_image/Dockerfile
	docker build -t $(NAME)-ruby21:$(VERSION) --rm ruby21_image

build_ruby22:
	rm -rf ruby22_image
	cp -pR image ruby22_image
	sed -i 's/BASE_IMAGE/passenger-ruby22/' ruby22_image/Dockerfile
	sed -i "s/VERSION/$(PASSENGER_VERSION)/" ruby22_image/Dockerfile
	docker build -t $(NAME)-ruby22:$(VERSION) --rm ruby22_image

build_full:
	rm -rf full_image
	cp -pR image full_image
	sed -i 's/BASE_IMAGE/passenger-full/' full_image/Dockerfile
	sed -i "s/VERSION/$(PASSENGER_VERSION)/" full_image/Dockerfile
	docker build -t $(NAME)-full:$(VERSION) --rm full_image

tag_latest:
	docker tag -f $(NAME)-ruby21:$(VERSION) $(NAME)-ruby21:latest
	docker tag -f $(NAME)-ruby22:$(VERSION) $(NAME)-ruby22:latest
	docker tag -f $(NAME)-full:$(VERSION) $(NAME)-full:latest

release: tag_latest
	@if ! docker images $(NAME)-ruby21 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby21 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby22 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby22 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-full | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-full version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)-ruby21
	docker push $(NAME)-ruby22
	docker push $(NAME)-full
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION)"

clean:
	rm -rf ruby21_image
	rm -rf ruby22_image
	rm -rf full_image

clean_images:
	docker rmi konsti/passenger-ruby21:latest konsti/passenger-ruby21:$(VERSION) || true
	docker rmi konsti/passenger-ruby22:latest konsti/passenger-ruby22:$(VERSION) || true
	docker rmi konsti/passenger-full:latest konsti/passenger-full:$(VERSION) || true
