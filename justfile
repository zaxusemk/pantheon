htmlpublic := "/config/www"

build-full:
  docker build -t zaxusemk/pantheon --target pantheon-full --build-arg HTMLPUBLIC={{htmlpublic}} .

build-bl4st:
  docker build -t zaxusemk/pantheon-bl4st --target pantheon-bl4st --build-arg HTMLPUBLIC={{htmlpublic}} .
