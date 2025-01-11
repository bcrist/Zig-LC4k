@pushd %~dp0examples
@for /D %%f in (*) do @(
    pushd %%f
    zig build -Doptimize=ReleaseSafe
    popd
)
@popd
