FROM perl:5
LABEL maintainer="david.williamson@varilink.co.uk"
ARG UID=1000

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN                                                                            \
  cpanm --notest                                                               \
    CSS::Simple                                                                \
    CSS::Tidy                                                                  \
    Data::Walk                                                                 \
    File::Find                                                                 \
    File::Slurp                                                                \
    JSON                                                                       \
    Ref::Util                                                                  \
    Scalar::Util                                                            && \
  chmod +x /usr/local/bin/docker-entrypoint.sh

COPY ./pl/ /usr/src/app/

USER ${UID}
WORKDIR /workdir/

COPY docker-entrypoint.sh /
ENTRYPOINT [ "docker-entrypoint.sh" ]
