OLD_REPONAME='marioczpn'
NEW_REPONAME='quay.io/marioczpn'
TAG='latest-kafka-2.5.1'

# extract image name, e.g. "old_name/image_name_1"
for image in $(docker images | awk '{ if( FNR>1 ) { print $1 } }' | grep $OLD_REPONAME)
do \
  OLD_NAME="${image}:${TAG}" && \
  NEW_NAME="${NEW_REPONAME}${image:${#OLD_REPONAME}:${#image}}:${TAG}" && \
  docker image tag $OLD_NAME $NEW_NAME 
# omit this line if you want to keep the old image && \
done