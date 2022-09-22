# SUPER small base image 
# https://lipanski.com/posts/smallest-docker-image-static-website
FROM lipanski/docker-static-website:latest

ADD app .

CMD ["/busybox", "httpd", "-f", "-v", "-p", "3000", "-c", "httpd.conf"]
