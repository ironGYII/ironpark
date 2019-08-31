ARG base_img
FROM $base_img
WORKDIR /
RUN mkdir ${SPARK_HOME}/python

RUN apk add --no-cache libffi-dev \
    openssl-dev \
    build-base \
    openssh \
    zlib-dev \
  && rm -rf /var/cache/apk/*

RUN wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz \
    && tar xvzf Python-3.7.3.tgz \
    && rm *.tgz \
    && cd Python-3.7.3 \
    && ./configure \
    && make \
    && make install \
    && ln -s /usr/local/bin/python3 /usr/bin/python

#RUN apk --update add libxml2-dev libxslt-dev musl-dev libgcc curl
#RUN apk add zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev
#
RUN apk update \
    && apk add --no-cache git \
       cmake \
       libstdc++ g++ \
       make \
       jpeg-dev \
       libpng-dev \
       giflib-dev \
       openblas-dev \
       ca-certificates \
    && rm -rf /var/cache/apk/*

ARG BRANCH=v19.13
RUN wget -c -q https://github.com/davisking/dlib/archive/${BRANCH}.tar.gz \
 && tar xf ${BRANCH}.tar.gz \
 && mv dlib-* dlib \
 && mkdir -p dlib/build \
 && (cd dlib/build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DDLIB_PNG_SUPPORT=ON -DDLIB_GIF_SUPPORT=ON -DDLIB_JPEG_SUPPORT=ON .. \
    && cmake --build . --config Release -- -j2 \
    && make install) \
 && rm -rf *.tar.gz /dlib/build

COPY data/python/lib ${SPARK_HOME}/python/lib
COPY . ${SPARK_HOME}/work-dir

ENV PYTHONPATH ${SPARK_HOME}/python/lib/pyspark.zip:${SPARK_HOME}/python/lib/py4j-*.zip

WORKDIR /opt/spark/work-dir


RUN mkdir dist \
  && python setup.py sdist -d dist \
  && pip3 install -U pip \
  && pip3 install dist/* \
  && ls | grep -vE "app|console_web|data|ironspark|main.py" | xargs rm -rf

ENTRYPOINT [ "/opt/entrypoint.sh"]
