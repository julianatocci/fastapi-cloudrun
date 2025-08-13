include ../../../make.inc

build_docker_image:
	docker build -t $(DOCKER_IMAGE_NAME) .

run_docker_image:
	docker run --rm -e PORT=${PORT} -p ${PORT}:${PORT} $(DOCKER_IMAGE_NAME)


push_docker_image:
	docker push $(DOCKER_IMAGE_NAME)

deploy_docker_image:
	gcloud run deploy $(IMAGE_NAME) \
		--image $(DOCKER_IMAGE_NAME) \
		--platform managed \
		--region $(LOCATION) \
		--allow-unauthenticated \
		--port $(PORT)
