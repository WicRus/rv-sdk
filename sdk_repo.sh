#!/bin/bash
source sdk_cfg

function __sdk_init() {
  if [ ! -d $REPO_PATH/.git ]; then
      git clone $REPO_URL $REPO_PATH
  else
      __pushd $REPO_PATH
          git pull
      __popd
  fi

  __pushd $SDK_PATH
      $REPO init --no-clone-bundle --no-repo-verify -u $MANIFEST_URL -b $MANIFEST_BRANCH -m $MANIFEST < /dev/null
      $REPO sync
  __popd
}

function __sdk_repo() {
  [ -f "$REPO" ] || {
    echo "repo was not initialized at: $REPO_PATH"
    return 1
  }

  __pushd $SDK_PATH
    $REPO "$@"
  __popd
}

function __sdk_repo_bash() {
  __sdk_repo forall -p -c bash -c "$@"
}

function __manifs_select() {
  local match=$1
  echo "=> selecting by pattern: '$match'..."

  local manifests=($(cd ${MANIFESTS_DIR}; ls *.xml | sed "s/.xml$//" | grep -- "$match" | sort))
  local selected
  if ! arr_selector manifests selected "$match"; then
    echo "=> => no matches found"
    return 1
  fi
  echo "=> => selected: $selected"

  echo "=> switching manifest..."
  sdk_repo init -m "$selected.xml"
}

function __manifs_git() {
  __pushd "$MANIFESTS_DIR"
    git $@
    ret=$?
  __popd
  return $ret
}

if [ "$1" == "init" ]; then
  [ -d "$MANIFESTS_DIR" ] && {
    echo "sdk already initialized, ignore init"
    echo "aborting..."
    exit 1
  }
  __sdk_init
  exit 0
fi

[ ! -d "$MANIFESTS_DIR" ] && {
  echo "sdk wasn't initialized, to init sdk try:"
  echo " $0 init"
  echo "aborting..."
  exit 1
}


RCMD="$1"
ARGS="${@:2}"
case $RCMD in
  bash) { __sdk_repo_bash "${ARGS}"    ; };;
  git)  { __sdk_repo_bash "git ${ARGS}"; };;
  msel) { __manifs_select "${ARGS}"    ; };;
  mgit) { __manifs_git    "${ARGS}"    ; };;
  "")   {
      echo "try:"
      echo "  init             - to get and init sdk"
      echo "  help             - to get git-repo help"
      echo "  bash [args]      - to execute bash command over all repositories"
      echo "  git  [cmd, args] - to execute git command over all repositories"
      echo "  msel [pattern]   - to select manifest from available ones"
      echo "  mgit [cmd, args] - to execute git command in manifests repository"
      echo "                   - else execute clean repo"
    };;
  *)    { __sdk_repo "$@"; };;
esac
