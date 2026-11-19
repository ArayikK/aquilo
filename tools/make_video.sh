#!/bin/sh
# Usage: tools/make_video.sh <input.mp4> <name>   e.g. station_1080_hy.mp4 station_hy
# Writes media/<name>_1080.mp4 (if input >= 1080p), media/<name>_720.mp4. No audio, faststart.
in="$1"; name="$2"; cd "$(dirname "$0")/.." || exit 1
h=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$in")
if [ "$h" -ge 1080 ]; then
  ffmpeg -v error -y -i "$in" -an -c:v libx264 -preset slow -crf 27 -vf scale=-2:1080 -pix_fmt yuv420p -movflags +faststart "media/${name}_1080.mp4"
fi
ffmpeg -v error -y -i "$in" -an -c:v libx264 -preset slow -crf 27 -vf "scale=-2:'min(720,ih)'" -pix_fmt yuv420p -movflags +faststart "media/${name}_720.mp4"
ls -la media/${name}_*.mp4
