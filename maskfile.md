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

### dev-tabs

> Open (or switch to) a wezterm workspace for a git worktree — edit + git tabs

**OPTIONS**

* worktree
    * flags: -w --worktree
    * type: string
    * desc: Worktree to open (basename or branch). Omit to fzf-pick.

~~~ruby
require 'json'
require 'shellwords'

# Universal source of worktrees: git itself. Covers worktrunk- and
# Claude-created worktrees alike, since both are just git worktrees.
raw = `git worktree list --porcelain 2>/dev/null`
abort "Not inside a git repo with worktrees." if raw.strip.empty?

worktrees = raw.split("\n\n").filter_map do |block|
  path = block[/^worktree (.+)$/, 1]
  next unless path
  branch = block[/^branch (.+)$/, 1]&.sub(%r{^refs/heads/}, "")
  { path: path, branch: branch }
end

selected = ENV["worktree"].to_s.strip
selected = nil if selected.empty?

if selected
  wt = worktrees.find do |w|
    File.basename(w[:path]) == selected || w[:branch] == selected ||
      w[:path] == File.expand_path(selected)
  end
  abort "No worktree matching '#{selected}'." unless wt
else
  rows = worktrees.map { |w| "#{File.basename(w[:path])}\t#{w[:branch] || "(detached)"}\t#{w[:path]}" }
  choice = IO.popen(["fzf", "--delimiter=\t", "--with-nth=1,2", "--prompt=worktree> "], "r+") do |io|
    io.puts rows.join("\n")
    io.close_write
    io.read
  end.to_s.strip
  abort "No worktree selected." if choice.empty?
  chosen_path = choice.split("\t").last
  wt = worktrees.find { |w| w[:path] == chosen_path }
end

dir = wt[:path]
abort "Directory not found: #{dir}" unless Dir.exist?(dir)
ws = File.basename(dir) # workspace name = worktree dir basename

# If a workspace with this name already has panes, just switch to it.
panes = JSON.parse(`wezterm cli list --format json`)
if (existing = panes.find { |p| p["workspace"] == ws })
  `wezterm cli activate-pane --pane-id #{existing["pane_id"]}`
  abort "Switched to existing workspace '#{ws}'."
end

# Edit tab (hx) — spawns a fresh window bound to the worktree's workspace.
edit_pane = `wezterm cli spawn --new-window --workspace #{ws.shellescape} --cwd #{dir.shellescape}`.strip
panes = JSON.parse(`wezterm cli list --format json`)
win_id = panes.find { |p| p["pane_id"] == edit_pane.to_i }["window_id"]
bottom_left = `wezterm cli split-pane --bottom --percent 30 --pane-id #{edit_pane} --cwd #{dir.shellescape}`.strip
`wezterm cli split-pane --right --percent 50 --pane-id #{bottom_left} --cwd #{dir.shellescape}`
`wezterm cli set-tab-title --pane-id #{edit_pane} "#{ws} - edit"`
IO.popen(["wezterm", "cli", "send-text", "--pane-id", edit_pane, "--no-paste"], "w") { |io| io.puts "hx" }

# Git tab (lazygit) — same window/workspace.
git_pane = `wezterm cli spawn --window-id #{win_id} --cwd #{dir.shellescape}`.strip
bottom_left_2 = `wezterm cli split-pane --bottom --percent 30 --pane-id #{git_pane} --cwd #{dir.shellescape}`.strip
`wezterm cli split-pane --right --percent 50 --pane-id #{bottom_left_2} --cwd #{dir.shellescape}`
`wezterm cli set-tab-title --pane-id #{git_pane} "#{ws} - git"`
IO.popen(["wezterm", "cli", "send-text", "--pane-id", git_pane, "--no-paste"], "w") { |io| io.puts "lazygit" }

# Focus the edit tab.
`wezterm cli activate-pane --pane-id #{edit_pane}`
puts "Opened workspace '#{ws}'."
~~~

### close-tabs

> Close a worktree's wezterm workspace (kills its tabs; leaves the worktree)

**OPTIONS**

* worktree
    * flags: -w --worktree
    * type: string
    * desc: Workspace to close. Omit to fzf-pick.

~~~ruby
require 'json'

panes = JSON.parse(`wezterm cli list --format json`)
workspaces = panes.map { |p| p["workspace"] }.uniq.reject { |w| w == "default" }
abort "No named workspaces to close." if workspaces.empty?

selected = ENV["worktree"].to_s.strip
selected = nil if selected.empty?

unless selected
  selected = IO.popen(["fzf", "--prompt=close workspace> "], "r+") do |io|
    io.puts workspaces.join("\n")
    io.close_write
    io.read
  end.to_s.strip
  abort "Nothing selected." if selected.empty?
end
abort "No workspace named '#{selected}'." unless workspaces.include?(selected)

# Move focus off the doomed workspace so the GUI lands somewhere sane.
if (other = panes.find { |p| p["workspace"] != selected })
  `wezterm cli activate-pane --pane-id #{other["pane_id"]}`
end

# Kill our own pane last, so this script survives long enough to finish.
self_pane = ENV["WEZTERM_PANE"].to_i
targets = panes.select { |p| p["workspace"] == selected }
             .sort_by { |p| p["pane_id"] == self_pane ? 1 : 0 }
targets.each { |p| `wezterm cli kill-pane --pane-id #{p["pane_id"]}` }
puts "Closed #{targets.size} pane(s) in workspace '#{selected}'."
~~~
