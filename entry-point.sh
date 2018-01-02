#!/usr/bin/env bash
set -e

exec yarn && \
cd /app/android && \
./gradlew "$@"