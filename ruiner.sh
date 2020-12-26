input() {
  echo "Input..."
  ffmpeg -hide_banner -loglevel warning -i godknows.mp3 -f mp3 pipe:
}

shorten() {
  echo "Shortening..."
  ffmpeg -hide_banner -loglevel warning -i pipe: -to 00:00:30 -f mp3 pipe:
}

slow() {
  echo "Slowing..."
  ffmpeg -hide_banner -loglevel warning -i pipe: -filter:a "atempo=0.5" -f mp3 pipe:
}

offset() {
  echo "Offsetting..."
  offset=200ms
  delay=10

  if [ "$#" -eq 2 ]; then
    offset=$1
    delay=$2
  fi

  ffmpeg -hide_banner -loglevel warning -i pipe: -filter_complex \
    "[0]asplit[out1][out2]; \
    [out2]adelay=$offset[outo]; \
    [outo]volume=enable='between(t,0,$delay)':volume=0[outd]; \
    [outd]afade=t=in:st=$delay:d=3[outf]; \
    [out1][outf]amix=inputs=2:duration=first" -f mp3 pipe:
}

output() {
  ffmpeg -hide_banner -loglevel warning -i pipe: pipeout.mp3 -y
}

chain() {
  input=godknows.mp3
  length=00:00:30
  offset=200ms

  input | shorten | offset 250ms 5 | offset 100ms 15 | output
}

ruin() {
  echo "Ruining..."
  input=godknows.mp3
  length=00:00:30
  offset=200ms
  delay=10

  if [ "$1" = "-i" ]; then
    shift
    input=$1
    shift
  fi
  if [ "$1" = "-l" ]; then
    shift
    length=$1
    shift
  fi
  if [ "$1" = "-o" ]; then
    shift
    offset=$1
    shift
  fi 
  if [ "$1" = "-d" ]; then
    shift
    delay=$1
    shift
  fi 

  ffmpeg -hide_banner -loglevel warning -i $input -to $length -filter_complex \
    "[0]asplit[out1][out2]; \
    [out2]adelay=$offset[outo]; \
    [outo]volume=enable='between(t,0,$delay)':volume=0[outd]; \
    [outd]afade=t=in:st=$delay:d=3[outf]; \
    [out1][outf]amix=inputs=2:duration=first" test.mp3 -y
  return
}

case "$1" in
  chain)
    chain
    exit 0
    ;;
  ruin)
    shift
    ruin $@
    exit 0
    ;;
  desync)
    shift
    ./desync.sh $@
    exit 0
    ;;
esac
