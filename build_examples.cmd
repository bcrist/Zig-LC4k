@pushd %~dp0examples
@for /D %%f in (*) do @(
    pushd %%f
    zig build run
    popd
)
@popd
