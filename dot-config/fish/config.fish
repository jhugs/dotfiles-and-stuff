if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path --path /opt/homebrew/bin
set fish_greeting

if type -q mise
    mise activate fish | source
end
