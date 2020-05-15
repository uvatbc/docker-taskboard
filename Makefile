IMAGE=uvatbc/docker-taskboard:latest
GITHUB_FOLDER=https://github.com/kiswa/TaskBoard/archive
GITHUB_RELEASE=0.3.1

.PHONY: up down prep_for_up build push pull it

up:
	if [ ! -e taskboard.db ] ; then \
		touch taskboard.db ; \
		sudo chown www-data:www-data taskboard.db ; \
	fi
	docker run \
		--rm -it \
		-v ${shell readlink -f taskboard.db}:/var/www/html/api/taskboard.db \
		-w /tmp/ \
		${IMAGE} \
		sudo /usr/sbin/apache2ctl -D FOREGROUND

prep_for_up:
	-rm -rf TaskBoard.tar.gz TaskBoard
	wget -O TaskBoard.tar.gz ${GITHUB_FOLDER}/v${GITHUB_RELEASE}.tar.gz
	tar -xf TaskBoard.tar.gz
	mv TaskBoard-${GITHUB_RELEASE} TaskBoard

build:
	docker build -t $(IMAGE) -f Dockerfile .

push:
	docker push $(IMAGE)

pull:
	docker pull $(IMAGE)

it:
	docker run \
		--rm -it \
		-v ${shell readlink -f taskboard.db}:/var/www/html/api/taskboard.db \
		-w /tmp/ \
		${IMAGE} \
		bash