desync() {
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
  esac

  echo "desyncing"
  input=godknows.mp3
  length=00:00:30
  speed=0.99

  #shorten
  ffmpeg -y -i $input -to $length -filter_complex \
    "channelsplit=channel_layout=stereo[FL][FR]; \
    [FR]atempo=$speed[FRS]; \
    [FL][FRS]join=inputs=2:channel_layout=stereo[out]" -map "[out]" remixed.mp3
  return
}

ruin() {
  echo "Ruining..."
  #read INPUT
  INPUT=godknows.mp3
  LENGTH=00:00:30
  OFFSET=200ms
  DELAY=10

  ffmpeg -i $INPUT -to $LENGTH -filter_complex \
    "[0]asplit[out1][out2]; \
    [out2]adelay=$OFFSET[outo]; \
    [outo]volume=enable='between(t,0,$DELAY)':volume=0[outd]; \
    [outd]afade=t=in:st=9:d=3[outf]; \
    [out1][outf]amix=inputs=2:duration=first" test.mp3 -y
  return
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
esac
