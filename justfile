htmlpublic := "/config/www"

build-all: build-bl4st build-hydra build-full

build-full:
  docker build -t zaxusemk/pantheon --target pantheon-full --build-arg HTMLPUBLIC={{htmlpublic}} .

build-bl4st:
  docker build -t zaxusemk/pantheon-bl4st --target pantheon-bl4st --build-arg HTMLPUBLIC={{htmlpublic}} .

build-hydra:
  docker build -t zaxusemk/pantheon-hydra --target pantheon-hydra --build-arg HTMLPUBLIC={{htmlpublic}} .


clean-images:
  docker image rm -f zaxusemk/pantheon-bl4st
  docker image rm -f zaxusemk/pantheon