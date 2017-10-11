NAME = konsti/passenger
PASSENGER_VERSION = 0.9.24
VERSION = 1.8.0

.PHONY: all build_all \
				build_ruby21 build_ruby22 build_ruby23 build_ruby24 build_full \
				tag_latest release clean clean_images

all: build_all

build_all: \
	build_ruby21 \
	build_ruby22 \
	build_ruby23 \
	build_ruby24 \
	build_full

build_ruby21:
	rm -rf ruby21_image
	cp -pR image ruby21_image
	sed -i '' 's/BASE_IMAGE/passenger-ruby21/' ruby21_image/Dockerfile
	sed -i '' "s/VERSION/$(PASSENGER_VERSION)/" ruby21_image/Dockerfile
	docker build -t $(NAME)-ruby21:$(VERSION) --rm ruby21_image

build_ruby22:
	rm -rf ruby22_image
	cp -pR image ruby22_image
	sed -i '' 's/BASE_IMAGE/passenger-ruby22/' ruby22_image/Dockerfile
	sed -i '' "s/VERSION/$(PASSENGER_VERSION)/" ruby22_image/Dockerfile
	docker build -t $(NAME)-ruby22:$(VERSION) --rm ruby22_image

build_ruby23:
	rm -rf ruby23_image
	cp -pR image ruby23_image
	sed -i '' 's/BASE_IMAGE/passenger-ruby23/' ruby23_image/Dockerfile
	sed -i '' "s/VERSION/$(PASSENGER_VERSION)/" ruby23_image/Dockerfile
	docker build -t $(NAME)-ruby23:$(VERSION) --rm ruby23_image

build_ruby24:
	rm -rf ruby24_image
	cp -pR image ruby24_image
	sed -i '' 's/BASE_IMAGE/passenger-ruby24/' ruby24_image/Dockerfile
	sed -i '' "s/VERSION/$(PASSENGER_VERSION)/" ruby24_image/Dockerfile
	docker build -t $(NAME)-ruby24:$(VERSION) --rm ruby24_image

build_full:
	rm -rf full_image
	cp -pR image full_image
	sed -i '' 's/BASE_IMAGE/passenger-full/' full_image/Dockerfile
	sed -i '' "s/VERSION/$(PASSENGER_VERSION)/" full_image/Dockerfile
	docker build -t $(NAME)-full:$(VERSION) --rm full_image

tag_latest:
	docker tag $(NAME)-ruby21:$(VERSION) $(NAME)-ruby21:latest
	docker tag $(NAME)-ruby22:$(VERSION) $(NAME)-ruby22:latest
	docker tag $(NAME)-ruby23:$(VERSION) $(NAME)-ruby23:latest
	docker tag $(NAME)-ruby24:$(VERSION) $(NAME)-ruby24:latest
	docker tag $(NAME)-full:$(VERSION) $(NAME)-full:latest

release: tag_latest
	@if ! docker images $(NAME)-ruby21 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby21 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby22 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby22 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby23 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby23 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby24 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ruby24 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-full | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-full version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)-ruby21
	docker push $(NAME)-ruby22
	docker push $(NAME)-ruby23
	docker push $(NAME)-ruby24
	docker push $(NAME)-full
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION)"

clean:
	rm -rf ruby21_image
	rm -rf ruby22_image
	rm -rf ruby23_image
	rm -rf ruby24_image
	rm -rf full_image

clean_images:
	docker rmi konsti/passenger-ruby21:latest konsti/passenger-ruby21:$(VERSION) || true
	docker rmi konsti/passenger-ruby22:latest konsti/passenger-ruby22:$(VERSION) || true
	docker rmi konsti/passenger-ruby23:latest konsti/passenger-ruby23:$(VERSION) || true
	docker rmi konsti/passenger-ruby24:latest konsti/passenger-ruby24:$(VERSION) || true
	docker rmi konsti/passenger-full:latest konsti/passenger-full:$(VERSION) || true
