#!/bin/bash

set -ex

BUILDER_NAME=opsbox-builder
if ! $(docker buildx ls |grep -q ${BUILDER_NAME}); then
  docker buildx create --name ${BUILDER_NAME}
fi

docker buildx use ${BUILDER_NAME}
docker buildx inspect --bootstrap

if [ $# -eq 1 ]; then
  _svc_name=$1
fi

function docker_buildx_svc() {
  _svc=$1
  _image=$(docker-compose config |yq ".services|to_entries|.[]| select(.key==\"${_svc}\")|.value.image")
  _context=$(docker-compose config |yq ".services|to_entries|.[]| select(.key==\"${_svc}\")|.value.build.context")
  _dockerfile=$(docker-compose config |yq ".services|to_entries|.[]| select(.key==\"${_svc}\")|.value.build.dockerfile")

  _build_args=$(docker-compose config |yq ".services|to_entries|.[]| select(.key==\"${_svc}\")|.value.build.args")
  _build_target=$(docker-compose config |yq ".services|to_entries|.[]| select(.key==\"${_svc}\")|.value.build.target")
  IFS=$'\n'
  _buildx_build_args=
  if [ "x${_build_args}" != "xnull" ]; then
    for _build_arg in ${_build_args}
    do
      _arg_str=$(echo ${_build_arg}|sed -e 's/: /=/')
  echo "--------${_arg_str}"
      _buildx_build_args="${_buildx_build_args} --build-arg ${_arg_str}"
    done
  fi

  if [ "x${_build_target}" != "xnull" ]; then
    _buildx_build_args="${_buildx_build_args} --target ${_build_target}"
  fi

  if [ "x${_dockerfile}" != "xnull" ]; then
    _buildx_build_args="${_buildx_build_args} -f ${_dockerfile}"
  fi

  IFS=' ' read -ra _buildx_build_args_arr <<< "$_buildx_build_args"


  docker buildx build --platform linux/amd64,linux/arm64 -t ${_image} ${_context} --push --pull --progress=plain ${_buildx_build_args_arr[@]} ${_build_opts}
}

if [ -n "$_svc_name" ]; then
  docker_buildx_svc ${_svc_name}
  exit 0
else
  for svc in $(docker-compose config |yq '.services|to_entries|.[]|.key')
  do
    docker_buildx_svc ${svc}
  done
fi