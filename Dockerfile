# Pull base image
ARG BASE_IMAGE_TAG
FROM openjdk:${BASE_IMAGE_TAG:-8u222-jdk-stretch}

# Env variables
ARG SCALA_VERSION
ENV SCALA_VERSION ${SCALA_VERSION:-2.13.0}
ARG SBT_VERSION
ENV SBT_VERSION ${SBT_VERSION:-1.3.0}

WORKDIR /root

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.tgz https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz && \
  tar zxf ./sbt-$SBT_VERSION.tgz && \
  export PATH=$PATH:./sbt/bin

# Prepare sbt
RUN \
  ./sbt/bin/sbt sbtVersion && \
  mkdir -p project && \
  echo "scalaVersion := \"${SCALA_VERSION}\"" > build.sbt && \
  echo "sbt.version=${SBT_VERSION}" > project/build.properties && \
  echo "case object Temp" > Temp.scala && \
  ./sbt/bin/sbt compile && \
  rm -r project && rm build.sbt && rm Temp.scala && rm -r target

  ADD entrypoint.sh /entrypoint.sh
  ENTRYPOINT ["/entrypoint.sh"]
