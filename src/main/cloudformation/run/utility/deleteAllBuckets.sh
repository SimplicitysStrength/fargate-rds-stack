#!/bin/bash


# Delete all buckets and their contents /!\
aws s3 ls | cut -d" " -f 3 | xargs -I{} aws s3 rb s3://{} --force