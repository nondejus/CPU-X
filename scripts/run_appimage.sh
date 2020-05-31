#!/bin/bash
# shellcheck disable=SC2155

# Functions
die() {
	echo "[FATAL] $*"
	exit 1
}

# Debug helpers
if [[ -n "$CPUX_APPIMAGE_DEBUG" ]]; then
	set -x
	env
fi

if [[ -n "$CPUX_APPIMAGE_GDB" ]]; then
	EXEC="gdb --cd usr/bin --args"
else
	EXEC="exec"
fi

# Export lot of variables
export APPDIR="${APPDIR:-"$(dirname "$(realpath "$0")")"}" # Workaround to run extracted AppImage
#export XDG_CONFIG_DIRS="$APPDIR/etc/xdg"
export XDG_DATA_DIRS="$APPDIR/usr/share:/usr/share:$XDG_DATA_DIRS"
export TEXTDOMAINDIR="$APPDIR/usr/share/locale"
export TERMINFO="$APPDIR/usr/share/terminfo"
export PATH="$APPDIR/usr/bin:$PATH"

# Launch application
cd "$APPDIR" || die "failed to set current directory to '$APPDIR'"
$EXEC "$APPDIR/usr/bin/cpu-x" "$@"
