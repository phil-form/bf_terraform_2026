#!/bin/bash

source ./environment.sh
aws --endpoint-url=http://localhost:4566 kinesis list-streams