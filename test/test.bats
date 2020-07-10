#!/usr/bin/env bats

setup(){
  cat /dev/null >| mockCalledWith

  declare -A -p MOCK_RETURNS=(
  ['kustomize']=""
  ['git']=""
  ) > mockReturns

  export INPUT_HEAD_REF='dev'
  export INPUT_BASE_REF='master'
  export TMP_DIR='/tmp/tmp.test'
}

teardown() {
  unset INPUT_HEAD_REF
  unset INPUT_BASE_REF
  unset TMP_DIR
}

@test "it runs with no kustomize directory" {
  run /kustdiff

  #expectStdOutContains "::set-output name=diff::``` diff%0A%0A```"

  expectMockCalled "/usr/local/bin/git checkout dev --quiet
/usr/local/bin/git checkout master --quiet
/usr/local/bin/git diff --no-index /tmp/tmp.test/master /tmp/tmp.test/dev"
}

#@test "Test"

# @test "it pushes branch as name of the branch" {
#   export GITHUB_REF='refs/heads/myBranch'

#   run /entrypoint.sh

#   expectStdOutContains "::set-output name=tag::myBranch"

#   expectMockCalled "/usr/local/bin/docker build -t my/repository:myBranch .
# /usr/local/bin/docker push my/repository:myBranch"
# }

function expectStdOutContains() {
  local expected=$(echo "${1}" | tr -d '\n')
  local got=$(echo "${output}" | tr -d '\n')
  echo "Expected: |${expected}|
  Got: |${got}|"
  echo "${got}" | grep "${expected}"
}

function expectMockCalled() {
  local expected=$(echo "${1}" | tr -d '\n')
  local got=$(cat mockCalledWith | tr -d '\n')
  echo "Expected: |${expected}|
  Got: |${got}|"
  echo "${got}" | grep "${expected}"
}