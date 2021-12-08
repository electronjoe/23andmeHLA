FROM r-base:4.0.5

ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8
RUN apt-get update && apt-get install -y \
		python3-pip \
		python3-dev

RUN apt-get install --no-install-recommends -y supervisor redis-server plink1.9 nginx

RUN Rscript -e 'install.packages("BiocManager")'
RUN Rscript -e 'BiocManager::install("HIBAG")'

## Prevent cache invalidation of requirements.txt every time another file is updated.
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install -r requirements.txt


## Copy everything else
COPY . /app
COPY nginx.conf /etc/nginx/nginx.conf
RUN chown -R docker:docker /app
CMD ["/usr/bin/supervisord", "-c", "/app/supervisord.conf"]
