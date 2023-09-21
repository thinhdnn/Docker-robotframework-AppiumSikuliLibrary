#!/bin/bash

# Argument: Path to the directory containing test suites
TEST_ARGS=$1

# Start Xvfb
nohup Xorg -nolisten tcp -noreset +extension GLX +extension RANDR +extension RENDER -dpi $SCREEN_DPI -logfile ./10.log -config /etc/X11/xorg.conf.d/xorg-dummy.conf $DISPLAY &

# Run Robot Framework tests
robot "$TEST_ARGS"