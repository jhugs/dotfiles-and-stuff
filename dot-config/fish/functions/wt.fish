# worktrunk shell integration for fish
# Sources full integration from binary on first use.
# Docs: https://worktrunk.dev/config/#shell-integration
# Check: wt config show | Uninstall: wt config shell uninstall

function wt
    # Re-entry guard: when invoked with COMPLETE set (during tab completion), the
    # binary emits a `complete` line instead of the init script, so `source` never
    # redefines this function. Without a guard, `wt $argv` below would re-enter the
    # shim forever -> "call stack limit exceeded". Strip COMPLETE for the bootstrap
    # and short-circuit to the binary if we somehow re-enter mid-load.
    if set -q __wt_loading
        command wt $argv
        return $status
    end
    set -lx __wt_loading 1
    set -e COMPLETE
    command wt config shell init fish | source
    # Check both command exit code ($pipestatus[1]) and source exit code ($pipestatus[2])
    # If source fails, the function isn't replaced and we'd infinite-loop calling ourselves
    set -l wt_status $pipestatus[1]
    set -l source_status $pipestatus[2]
    test $wt_status -eq 0; or return $wt_status
    test $source_status -eq 0; or return $source_status
    wt $argv
end
