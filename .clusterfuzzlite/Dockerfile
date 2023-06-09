FROM gcr.io/oss-fuzz-base/base-builder-python

COPY . $SRC/cronk
WORKDIR $SRC/cronk
COPY ./.clusterfuzzlite/build.sh $SRC/

RUN pip3 install hypothesis
RUN pip3 install -r requirements.txt