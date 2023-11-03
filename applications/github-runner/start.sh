#!/usr/bin/env bash

sudo --preserve-env=PATH env nomad agent -config=${PWD}/config -data-dir=${PWD}/.data
