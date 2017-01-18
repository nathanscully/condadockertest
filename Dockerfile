FROM gettyimages/spark:2.0.2-hadoop-2.7
# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Deps
RUN set -ex \
    && buildDeps='git build-essential pkg-config libglib2.0-0 libxext6 libsm6 libxrender1 libpq-dev gcc' \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        apt-utils \
        apt-transport-https \
        wget \
        ca-certificates \
        bzip2 \
        libfontconfig \
        vim \
        telnet \
        curl \
    && echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh \
    && wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.1.11-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh \
    && wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
    && tar -zxf apache-maven-3.3.9-bin.tar.gz -C /usr/local/ \
    && ln -s /usr/local/apache-maven-3.3.9/bin/mvn /usr/local/bin/mvn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/conda/bin:$PATH


RUN condaDeps='cython scipy scikit-learn scikit-image pandas matplotlib nltk psycopg2 pytz simplejson sqlalchemy boto gensim' \
    && conda install nomkl \
    && conda install $condaDeps -y \
    && pip install --upgrade pip \
    && pip install --ignore-installed setuptools \
    && pipDeps='abba tensorflow progressbar2 sqlalchemy-redshift statsmodels awscli' \
    && pip install --upgrade $pipDeps \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get update  -yqq \
    && apt-get install -yqq --no-install-recommends nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update  -yqq \
    && apt-get install -yqq --no-install-recommends yarn \
    && apt-get autoremove \
    && apt-get remove --purge -yqq $buildDeps yarn nodejs npm \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base \
        /root/.m2 \
        /root/.npm \
        /root/.cache \
        /usr/src/zeppelin \
    && conda clean --tarballs --source-cache --index-cache -y

CMD ["echo","hello"]
