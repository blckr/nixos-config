# fish completions for kit. Nix fills in the @…@ placeholders at build time.
complete -c kit -f

set -l commands build switch keys light dark theme help
complete -c kit -n "not __fish_seen_subcommand_from $commands" -a build -d "Build and show the difference"
complete -c kit -n "not __fish_seen_subcommand_from $commands" -a switch -d "Build and activate"
complete -c kit -n "not __fish_seen_subcommand_from $commands" -a keys -d "Show keybindings"
complete -c kit -n "not __fish_seen_subcommand_from $commands" -a light -d "Light appearance"
complete -c kit -n "not __fish_seen_subcommand_from $commands" -a dark -d "Dark appearance"
complete -c kit -n "not __fish_seen_subcommand_from $commands" -a theme -d "Switch or list colour themes"
complete -c kit -n "not __fish_seen_subcommand_from $commands" -a help -d "Show help"

complete -c kit -n "__fish_seen_subcommand_from build switch; and not __fish_seen_subcommand_from @targets@" -a "@targets@"
complete -c kit -n "__fish_seen_subcommand_from keys; and not __fish_seen_subcommand_from @keys@" -a "@keys@"
complete -c kit -n "__fish_seen_subcommand_from theme; and not __fish_seen_subcommand_from @themes@" -a "@themes@"
