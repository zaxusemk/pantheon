htmlpublic := "/config/www"

build-all: build-bl4st build-hydra build-openscope build-it-tools build-adarkroom build-full

build-full:
  docker build -t zaxusemk/pantheon --target pantheon-full --build-arg HTMLPUBLIC={{htmlpublic}} .

build-bl4st:
  docker build -t zaxusemk/pantheon-bl4st --target pantheon-bl4st --build-arg HTMLPUBLIC={{htmlpublic}} .

build-hydra:
  docker build -t zaxusemk/pantheon-hydra --target pantheon-hydra --build-arg HTMLPUBLIC={{htmlpublic}} .

build-openscope:
  docker build -t zaxusemk/pantheon-openscope --target pantheon-openscope --build-arg HTMLPUBLIC={{htmlpublic}} .

build-it-tools:
  docker build -t zaxusemk/pantheon-it-tools --target pantheon-it-tools --build-arg HTMLPUBLIC={{htmlpublic}} .

build-adarkroom:
  docker build -t zaxusemk/pantheon-adarkroom --target pantheon-adarkroom --build-arg HTMLPUBLIC={{htmlpublic}} .

clean-images:
  docker image rm -f zaxusemk/pantheon-bl4st
  docker image rm -f zaxusemk/pantheon-hydra
  docker image rm -f zaxusemk/pantheon-openscope
  docker image rm -f zaxusemk/pantheon-it-tools
  docker image rm -f zaxusemk/pantheon-adarkroom
  docker image rm -f zaxusemk/pantheon