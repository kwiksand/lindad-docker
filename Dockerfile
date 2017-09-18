FROM quay.io/kwiksand/cryptocoin-base:latest

RUN useradd -m linda

ENV DAEMON_RELEASE=1.0.1.1
ENV LINDA_DATA=/home/linda/.linda

RUN apt-get install -y libgmp-dev && \
    git clone https://github.com/bitcoin/secp256k1.git && \
    cd secp256k1 && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

USER linda

RUN cd /home/linda && \
    mkdir .ssh && \
    chmod 700 .ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone  --branch $DAEMON_RELEASE https://github.com/Lindacoin/Linda.git lindad && \
    cd /home/linda/lindad/src && \
    make -f makefile.unix && \
    strip Lindad
    
EXPOSE 3821 3822

#VOLUME ["/home/linda/.linda"]

USER root

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh && \
    chmod 755 /home/linda/lindad/src/Lindad && \
    ln -s /home/linda/lindad/src/Lindad /usr/bin/

ENTRYPOINT ["/entrypoint.sh"]

CMD ["Lindad"]
