#!/bin/sh

script=$1
shift

exec perl "/usr/src/app/$script" "$@"
