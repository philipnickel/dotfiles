function rr --description "Remote run: rsync + execute on remote host"
    if test (count $argv) -lt 2
        echo "Usage: rr <host> <command...>"
        echo "       rr -d <host> <command...>  (detached, survives disconnect)"
        return 1
    end

    set detached false
    if test $argv[1] = "-d"
        set detached true
        set --erase argv[1]
    end

    set host $argv[1]
    set cmd (string join " " $argv[2..])
    set dir (basename $PWD)
    set remote "~/remote-runs/$dir"

    echo "Syncing to $host:$remote..."
    rsync -az --info=progress2 --delete \
        --exclude .git \
        --exclude __pycache__ \
        --exclude .venv \
        --exclude '*.egg-info' \
        --exclude .mypy_cache \
        --exclude .ruff_cache \
        --exclude wandb \
        --exclude .uv \
        ./ $host:$remote/

    if test $detached = true
        echo "Launching detached on $host..."
        ssh $host "cd $remote && nohup $cmd > output.log 2>&1 & echo PID: \$!"
        echo "Streaming output (Ctrl-C to stop watching, job keeps running)..."
        ssh $host "tail -f $remote/output.log"
    else
        echo "Running on $host (Ctrl-C to cancel)..."
        ssh $host "cd $remote && $cmd"
    end
end
