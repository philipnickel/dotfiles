function hydra_fish_completion
    set -lx COMP_LINE (commandline -cp)

    set -l parts (commandline -cpo)
    if test "$parts[1]" = "python" -o "$parts[1]" = "python3"
        set cmd "$parts[1] $parts[2]"
        if not grep -q "@hydra.main" $parts[2]
            return
        end
    else
        set cmd "$parts[1]"
    end

    eval "$cmd -sc query=fish"
end

complete -c python -n '__fish_seen_subcommand_from simulate.py' -x -a '(hydra_fish_completion)'
complete -c python3 -n '__fish_seen_subcommand_from simulate.py' -x -a '(hydra_fish_completion)'
