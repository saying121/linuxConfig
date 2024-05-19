#!/usr/bin/env bash

socket=http://127.0.0.1:7897

export ALL_PROXY=$socket
export HTTPS_PROXY=$socket
export HTTP_PROXY=$socket
