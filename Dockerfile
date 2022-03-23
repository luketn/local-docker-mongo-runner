# Builder image (published to luketn/mongo-docker-in-docker) adding Docker to the latest Mongo image (for Docker-in-Docker run)
FROM mongo

RUN apt-get update && apt-get install -y wget tar zip unzip

RUN set -eux; \
	arch="$(dpkg --print-architecture)" && \
	case "$arch" in \
		'amd64') \
			url='https://download.docker.com/linux/static/stable/x86_64/docker-20.10.13.tgz' && \
			aws_url='https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' \
			;; \
		'arm64') \
			url='https://download.docker.com/linux/static/stable/aarch64/docker-20.10.13.tgz' && \
            aws_url='https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip' \
			;; \
		*) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;; \
	esac && \
	wget -O docker.tgz "$url" && \
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ && \
	rm docker.tgz && \
	dockerd --version && \
	docker --version && \
	wget -O awscliv2.zip "$aws_url" && \
	unzip awscliv2.zip && \
	./aws/install && \
	rm awscliv2.zip && \
	aws --version

RUN mkdir -p /opt/build
WORKDIR /opt/build

ENTRYPOINT ["/bin/bash"]
