# voice-type

System-wide voice-to-text on Linux using a hotkey toggle. Press **Alt+X** to start recording, press again to stop - your speech is transcribed and typed wherever your cursor is.

Uses [Groq's](https://groq.com/) cloud Whisper API for fast, accurate transcription.

## How it works

1. **First press (Alt+X):** Starts recording from your microphone via `ffmpeg`
2. **Second press (Alt+X):** Stops recording, sends audio to Groq's Whisper API, types the transcribed text at your cursor position and copies it to clipboard

## Scripts

| Script | Description |
|--------|-------------|
| `voice-type` | **Main script** - Groq cloud Whisper, works on Wayland via ydotool |
| `voice-type-live` | Live transcription variant using local faster-whisper (types as you speak) |
| `voice-type-local.sh` | Original version using local whisper CLI (X11/xdotool) |
| `whisper-local` | Standalone wrapper for local faster-whisper transcription |

## Setup

### 1. Dependencies

```bash
sudo apt install ffmpeg ydotool wl-clipboard libnotify-bin
pip install requests
```

### 2. API Key

Get a free API key from [Groq Console](https://console.groq.com/).

```bash
mkdir -p ~/voice-type-config
cp config.example ~/voice-type-config/config
# Edit ~/voice-type-config/config and add your Groq API key
```

### 3. Install

```bash
cp voice-type ~/.local/bin/
chmod +x ~/.local/bin/voice-type
```

### 4. Bind hotkey

In GNOME Settings > Keyboard > Custom Shortcuts, add:
- **Name:** Voice Type
- **Command:** `/home/YOUR_USER/.local/bin/voice-type`
- **Shortcut:** Alt+X

### Optional: Local transcription (no API needed)

```bash
pip install faster-whisper
cp voice-type-live ~/.local/bin/
chmod +x ~/.local/bin/voice-type-live
```

## Notes

- Works on **Wayland** (GNOME) using `ydotool` for text input
- Audio is recorded to `/tmp/voice-recording.wav` and **deleted after each use**
- Transcripts are logged to `/tmp/voice-type-transcripts.log` (cleared on reboot)
- The `voice-type-local.sh` variant uses `xdotool` and works on X11
