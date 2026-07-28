BRANCH=$(git rev-parse --abbrev-ref HEAD | tr '/' '-')
docker build . -f docker/k8s-glue/microblink-agent/Dockerfile -t europe-docker.pkg.dev/microblink-shared-services/aip/clearml/clearml-agent:$BRANCH
docker push europe-docker.pkg.dev/microblink-shared-services/aip/clearml/clearml-agent:$BRANCH
