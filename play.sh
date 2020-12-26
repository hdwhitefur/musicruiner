argtest() {
  case "$1" in
  
}

case "$1" in
  ruin)
    echo "help"
    ;;
  desync)
    shift
    if test $# -gt 0; then
      desync $1
    else
      desync godknows.mp3
    fi
    ;;
  arg) ;;
esac
