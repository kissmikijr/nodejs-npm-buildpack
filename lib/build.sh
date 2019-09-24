#!/usr/bin/env bash

detect_package_lock() {
  local build_dir=$1
  [[ -f "$build_dir/package-lock.json" ]]
}

use_npm_ci() {
  local npm_version=$(npm -v)
  local major=$(echo $npm_version | cut -f1 -d ".")
  local minor=$(echo $npm_version | cut -f2 -d ".")

  [[ "$major" > "5" || ("$major" == "5" || "$minor" > "6") ]]
}

install_or_reuse_node_modules() {
  local build_dir=$1

  if detect_package_lock $build_dir ; then
    echo "---> Restoring node modules from ./package-lock.json"
    if use_npm_ci ; then
      npm ci
    else
      npm install
    fi
  else
    echo "---> Installing node modules"
    npm install --no-package-lock
  fi
}
