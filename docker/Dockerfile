FROM 3proxy/3proxy:latest
LABEL maintainer="Andrey Bagrintsev <andrey@bagrintsev.me>"

COPY ./docker/entrypoint.sh /usr/local/bin/
VOLUME /usr/local/3proxy/conf

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
