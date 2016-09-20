#!/bin/bash

set -ex

./exe/ws validate --ignored-paths features tmp vendor

if bundle show rubocop &> /dev/null; then
  bundle exec rubocop
fi

bundle exec rspec
bundle exec cucumber --format progress
