# From:
# - https://github.com/nakulj/auto-venv/blob/369223d5db4cba4acbc85b266174f94855c413e8/conf.d/venv.fish
# which is based on:
# - https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e
# - https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f


# Changes:
# * Not based on cd, have user call avenv as tools like uv prefer to activate themselves
# * Update syntax to work with new versions of fish.

function avenv --description "Activate/Deactivate virtualenv on directory change"
    status --is-command-substitution; and return

    # Searched directories are the current directory, and the root of the current git repo if applicable
    set __cdirs (pwd)
    if git rev-parse --show-toplevel &>/dev/null
        set -a __cdirs (realpath (git rev-parse --show-toplevel))
    end

    # Scan directories for a fish-compatible virtual environment
    set VENV_DIR_NAMES env .env venv .venv
    for venv_dir in $__cdirs/$VENV_DIR_NAMES
        if test -e "$venv_dir/bin/activate.fish"
            break
        end
    end

    # Activate venv if it was found and not activated before
    if test "$VIRTUAL_ENV" != "$venv_dir" -a -e "$venv_dir/bin/activate.fish"
        source $venv_dir/bin/activate.fish
        # Deactivate venv if it is activated but the directory doesn't exist
    else if not test -z "$VIRTUAL_ENV" -o -e "$venv_dir"
        deactivate
    end
end
