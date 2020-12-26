argtest() {
  if [ "$1" = "-a" ]; then
    shift
    echo "$1"
    shift
  fi
  if [ "$1" = "-b" ]; then
    shift
    echo "$1"
    shift
  fi
}

case "$1" in
  arg)
    shift
    if test $# -gt 0; then
      argtest $@ #pass all arguments
    fi
    ;;
esac
