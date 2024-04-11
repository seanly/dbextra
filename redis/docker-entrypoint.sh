#!/bin/bash

_redis_opts=

if [ -n "${REDIS_PSW}" ]; then
  _redis_opts="--requirepass ${REDIS_PSW} ${_redis_opts}"
fi

if [ -n "${REDIS_OPTS}" ]; then
  _redis_opts="${_redis_opts} ${REDIS_OPTS}"
fi

exec redis-server ${_redis_opts}