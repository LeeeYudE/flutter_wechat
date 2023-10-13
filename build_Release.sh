#! /bin/bash

# 打包显示的日志

_tag=v2.0.0

git tag ${_tag}
git push --tags
git commit --allow-empty -m "[build] Release ${_tag}"
git push origin $branchg