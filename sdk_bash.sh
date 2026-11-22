#!/bin/bash
source sdk_cfg
if [ -z $D_Q ]; then
  docker run $D_FLAGS $D_IMG:$D_TAG bash "$@" &> /dev/null
else
  docker run $D_FLAGS $D_IMG:$D_TAG bash "$@"
fi
