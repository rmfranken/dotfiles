#!/usr/bin/env bash
set -euo pipefail
echo "==> Fixing PulseAudio configuration to prevent unwanted suspensions..."

# Ensure PulseAudio user config exists
mkdir -p ~/.config/pulse

# Copy system default.pa if user version doesn't exist
if [ ! -f ~/.config/pulse/default.pa ]; then
    cp /etc/pulse/default.pa ~/.config/pulse/default.pa
fi

# Disable module-suspend-on-idle (idempotent)
grep -q '^#.*module-suspend-on-idle' ~/.config/pulse/default.pa || \
    sed -i 's/^\(load-module module-suspend-on-idle\)/# \1/' ~/.config/pulse/default.pa

# Restart PulseAudio to apply changes
pulseaudio --kill
pulseaudio --start
