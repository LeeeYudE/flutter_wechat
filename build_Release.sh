#! /bin/bash

# 打包显示的日志

_tag=v1.0.2

git tag ${_tag}
git push --tags
git commit --allow-empty -m "[build] Release ${_tag}"
git push origin $branchg