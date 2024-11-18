TOOLS_PATH="$HOME/.tools/bin"

if [ ! -d "$TOOLS_PATH" ]; then
    mkdir -p "$TOOLS_PATH"

    cd tools/launch-dev
    zig build
    mv zig-out/bin/launch-dev "$TOOLS_PATH"
    cd ../..
fi
