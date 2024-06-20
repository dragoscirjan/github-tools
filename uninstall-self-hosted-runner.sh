#! /bin/bash
if [ ! -z $DEBUG ]; then
    set -ex
fi

GITHUB_REPOSITORY=${GITHUB_REPOSITORY:-invalid}
GITHUB_TOKEN=${GITHUB_TOKEN:-invalid}

example="
DEBUG=1 \
RUNNER_FOLDER_PATTERN="action-runner-*-performance" \ \
bash ./uninstall-self-hosted-runner.sh
"

function uninstall_runner() {
  local runnerFolderPattern=${RUNNER_FOLDER_PATTERN:-"action-runner-{id}"}

  find $HOME -maxdepth 1 -type d -iname "$runnerFolderPattern" | while read runnerFolder; do
    cd $runnerFolder

    sudo ./svc.sh stop || true
    sudo ./svc.sh uninstall || true

    ./config.sh remove --token $GITHUB_TOKEN || true

    cd $HOME

    rm -rf $runnerFolder
  done
}

if [[ "$GITHUB_TOKEN" == "invalid" ]]; then
    echo "Invalid Github Token. Not mentioned."
    exit 2
fi

uninstall_runner
