# https://github.com/pry/pry
#
# https://github.com/lucapette/dotfiles/blo0b/master/pryrc
# http://lucapette.com/pry/pry-everywhere/
# https://github.com/AndrewO/ruby-debug-pry
# https://gist.github.com/941174 - rails and pry
Pry.config.editor = "vim --nofork"

Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'
