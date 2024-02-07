# if [[ $(ps -ef | rg '\bags\b' | wc -l) -gt 0 ]]; then echo "ags"; else echo "no ags"; fi
if [[ $(ps -ef | rg '\bags\b' | wc -l) -gt 0 ]]; then ags -r "audio.speaker.volume += 0.05; indicator.speaker()"; else wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+; fi # 调大音量
