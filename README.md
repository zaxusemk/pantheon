# Pantheon
A self-hosting oriented container of static web tools and web games, all served via linuxserver.io's nginx.

# Why?
Why not? Also, as a hobbyist I run my homelab on some pretty limited hardware (cough Raspberry Pi cough), and it occured to me that a bunch of the things I want to self-host are just static websites that could easily be served from a single nginx container instance.

Plus, it's an exucse to fool around with Docker (and node, and just, and python, and...)

# Todo
 - Add a simple but beautiful build-time generated index page
 - Add build targets for app categories (games, tools, etc)

# Building the images
You'll need to have:
 - a working just installation
 - a working Docker build environment

 Once that's set up, play around with the following just recipes:
  - build-full - Builds the full pantheon image, with every app in it's own nginx folder
  - build-{x} - Build an nginx image for a single app, where x is the app name
  - build-all - Build the full pantheon image AND all of the single app images

  Other recipes of note:
  - clean-images - Removed all of the pantheon images from your local Docker repo.