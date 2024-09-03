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
require 'colorize'

puts 'lint:frontend: linting...'.yellow

output = `$MASK gda | ag "\\.(ts|js|jsx|tsx)" | xargs -I% eslint_d --fix %`
puts output.red unless $?.success?

puts 'done.'.yellow
~~~

### ruby

> lint .rb files with rubocop

~~~ruby

require 'colorize'
 
puts "lint:ruby linting...".yellow

output = `$MASK gda | ag "\\.(rb)" | xargs -I% bundle exec rubocop -a %`
unless $?.success?
	puts output.red
end

puts "done.".yellow
~~~
