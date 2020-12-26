desync() {
  echo "desyncing"
  INPUT=$1
  OUTPUT=date +"%T"

  #shorten
  ffmpeg -y -i $INPUT -to 00:00:30 -filter_complex \
    "channelsplit=channel_layout=stereo[FL][FR]; \
    [FR]atempo=0.99[FRS]; \
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

lazy() {
  ruin godknows.mp3 00:00:30 200ms 10
}

val1() {
  echo | expr $1 + 1
}

val() {
  val1 $1
}

case "$1" in
  ruin)
    echo "help"
    ;;
  desync)
	  shift
    if test $# -gt 0; then
      desync $1
    fi
    ;;
esac