FROM ubuntu:22.04

ARG PROVIDER=base

USER root
WORKDIR /root

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV PYTHONIOENCODING=UTF-8

COPY ./docker/k8s-glue/build-resources/setup.sh /root/setup.sh
COPY ./docker/k8s-glue/build-resources/entrypoint.sh /root/entrypoint.sh
RUN bash /root/setup.sh

COPY ./docker/k8s-glue/glue-build-multi/providers/${PROVIDER}/setup.sh /root/setup_provider.sh
RUN bash /root/setup_provider.sh

COPY ./docker/k8s-glue/glue-build-multi/providers/${PROVIDER}/provider_entrypoint.sh /root/provider_entrypoint.sh
COPY ./examples/k8s_glue_example.py /root/k8s_glue_example.py
COPY ./docker/k8s-glue/build-resources/clearml.conf /root/clearml.conf

COPY ./requirements.txt ./setup.py ./README.md /app/clearml-agent/
COPY ./clearml_agent /app/clearml-agent/clearml_agent
WORKDIR /app/clearml-agent
RUN python3 -m pip install --no-cache-dir .

WORKDIR /root

ENTRYPOINT ["/root/entrypoint.sh"]
