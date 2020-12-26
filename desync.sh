echo "Desyncing..."
input=godknows.mp3
length=00:00:30
speed=0.99

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
if [ "$1" = "-s" ]; then
  shift
  speed=$1
  shift
fi 

ffmpeg -hide_banner -loglevel warning -y -i $input -to $length -filter_complex \
  "channelsplit=channel_layout=stereo[FL][FR]; \
  [FR]atempo=$speed[FRS]; \
  [FL][FRS]join=inputs=2:channel_layout=stereo[out]" -map "[out]" remixed.mp3

echo "Done."

exit 0