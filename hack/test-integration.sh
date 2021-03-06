#!/bin/bash

# This script runs all of the integration test suites.
source "$(dirname "${BASH_SOURCE}")/lib/init.sh"
os::util::environment::setup_time_vars

function cleanup() {
  return_code=$?
  os::test::junit::generate_report
  os::cleanup::all
  os::util::describe_return_code "${return_code}"
  exit "${return_code}"
}
trap "cleanup" EXIT

os::cleanup::tmpdir

for test in $(find "${OS_ROOT}/test/integration" -name '*.sh'); do
  if ! ${test}; then
    failed="true"
    os::log::error "integration suite ${test} failed"
  fi
done

if [[ -n "${failed:-}" ]]; then
    os::log::fatal "integration suites failed"
fi
os::log::info "integration suites successful"
