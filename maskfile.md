# My tasks

## gda

> git:diff:all

~~~ruby
puts `(git diff --diff-filter=MA --ignore-space-at-eol --name-only origin/main...; git diff --name-only)`.lines.uniq
~~~

## lint

> Various linting commands

### frontend

> lint js/jsx/ts/tsx files

~~~ruby
require "#{ENV["MASKFILE_DIR"]}/utils.rb"

puts 'lint:frontend: linting...'.yellow

output = `$MASK gda | ag "\\.(ts|js|jsx|tsx)" | xargs eslint_d --fix`
puts output.red unless $?.success?

puts 'done.'.yellow
~~~

### ruby

> lint .rb files with rubocop

~~~ruby
require "#{ENV["MASKFILE_DIR"]}/utils.rb"
 
puts "lint:ruby linting...".yellow

output = `$MASK gda | ag "\\.(rb)" | xargs -I% bundle exec rubocop -a %`
unless $?.success?
	puts output.red
end

puts "done.".yellow
~~~

## wez

> WezTerm layout utilities

### dev-tabs (directory)

> Create an edit + git tab pair for a directory

~~~ruby
require 'json'

dir = File.expand_path(ENV["directory"])
abort "Directory not found: #{dir}" unless Dir.exist?(dir)
dirname = File.basename(dir)

pane_id = ENV["WEZTERM_PANE"]
abort "WEZTERM_PANE not set — run this from inside WezTerm" unless pane_id

panes = JSON.parse(`wezterm cli list --format json`)
window = panes.find { |p| p["pane_id"] == pane_id.to_i }
abort "Could not find window for pane #{pane_id}" unless window
win_id = window["window_id"]

# Edit tab (hx)
edit_pane = `wezterm cli spawn --window-id #{win_id} --cwd "#{dir}"`.strip
bottom_left = `wezterm cli split-pane --bottom --percent 30 --pane-id #{edit_pane} --cwd "#{dir}"`.strip
`wezterm cli split-pane --right --percent 50 --pane-id #{bottom_left} --cwd "#{dir}"`
`wezterm cli set-tab-title --pane-id #{edit_pane} "#{dirname} - edit"`
IO.popen(["wezterm", "cli", "send-text", "--pane-id", edit_pane, "--no-paste"], "w") { |io| io.puts "hx" }

# Git tab (lazygit)
git_pane = `wezterm cli spawn --window-id #{win_id} --cwd "#{dir}"`.strip
bottom_left_2 = `wezterm cli split-pane --bottom --percent 30 --pane-id #{git_pane} --cwd "#{dir}"`.strip
`wezterm cli split-pane --right --percent 50 --pane-id #{bottom_left_2} --cwd "#{dir}"`
`wezterm cli set-tab-title --pane-id #{git_pane} "#{dirname} - git"`
IO.popen(["wezterm", "cli", "send-text", "--pane-id", git_pane, "--no-paste"], "w") { |io| io.puts "lazygit" }

# Focus the edit tab
`wezterm cli activate-pane --pane-id #{edit_pane}`
~~~
