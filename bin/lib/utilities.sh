disable_error_trapping () {
  set +e # turn off error-trapping
}

contains () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

handle_error () {
  RETURN_CODE=$?

  if [ $RETURN_CODE -eq 1 ]; then
    echo ${1:-"Error with status code $RETURN_CODE"}
    exit 1 # force pipeline to fail
  fi

  set -e # turn on error-trapping
}

prompt_string () {
  read -p "$@: " STRING_INPUT
  echo $STRING_INPUT
}

rm_dir () {
  echo "*** Deleting directory $1"
  rm -rf $1
}
