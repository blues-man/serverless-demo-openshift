#!/bin/bash -x

# define the container base image
nodecontainer=$(buildah from gcr.io/distroless/nodejs)
# mount the container root FS
nodemnt=$(buildah mount $nodecontainer)

# make the java app directory
mkdir -p $nodemnt/app

# copy application directory, with Knative build templates, the app sources gets loaded in the /workspace directory
# adjust application name accordingly
cd /workspace/${CONTEXT_DIR}
cp -rv ./ $nodemnt/app/

chmod -R ug+=wx $nodemnt/app

buildah config --workingdir /app $nodecontainer
buildah config --cmd /app/${APP_MAIN} $nodecontainer

imageID=$(buildah commit $nodecontainer $IMAGE_NAME)

# Push the image back to local default docker registry
# you can also push to external registry 
# Refer to https://github.com/containers/buildah/blob/master/docs/buildah-push.md

# HTTPS
# buildah push --cert-dir=/var/run/secrets/kubernetes.io \
#   --creds=openshift:$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) \
#    $imageID \
#    docker://docker-registry.default.svc.cluster.local:5000/$IMAGE_NAME

## HTTP
buildah push --tls-verify=false \
  --creds=openshift:$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) \
   $imageID \
   docker://docker-registry.default.svc:5000/$POD_NAMESPACE/$IMAGE_NAME
