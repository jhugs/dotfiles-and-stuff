if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path --path /opt/homebrew/bin
set fish_greeting

if type -q mise
    mise activate fish | source
end

export EDITOR=hx
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/dotfiles-and-stuff/bin:$HOME/go/bin:$PATH"
