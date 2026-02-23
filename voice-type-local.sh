#!/bin/bash
# Voice typing script using local Whisper model (X11 version with xdotool)

TEMP_AUDIO="/tmp/voice_recording.wav"
PIDFILE="/tmp/voice_recording.pid"

# Check if already recording
if [ -f "$PIDFILE" ]; then
    # Stop recording
    PID=$(cat "$PIDFILE")
    kill $PID 2>/dev/null
    rm "$PIDFILE"

    # Wait a moment for the file to be written
    sleep 0.5

    # Transcribe with Whisper
    if [ -f "$TEMP_AUDIO" ]; then
        notify-send "Voice Typing" "Transcribing..."
        TEXT=$(~/.local/bin/whisper "$TEMP_AUDIO" --model tiny.en --language en --task transcribe --output_format txt --output_dir /tmp 2>/dev/null)

        # Get the transcribed text from the output file
        if [ -f "/tmp/voice_recording.txt" ]; then
            TEXT=$(cat "/tmp/voice_recording.txt")
            # Type the text
            xdotool type --clearmodifiers "$TEXT"
            rm "/tmp/voice_recording.txt"
        fi

        rm "$TEMP_AUDIO"
        notify-send "Voice Typing" "Done!"
    fi
else
    # Start recording
    notify-send "Voice Typing" "Recording... (press hotkey again to stop)"
    ffmpeg -f pulse -i default -acodec pcm_s16le -ar 16000 "$TEMP_AUDIO" 2>/dev/null &
    echo $! > "$PIDFILE"
fi
