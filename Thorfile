require 'rubygems'
require 'thor'

# rubocop:disable Style/ClassAndModuleChildren
class ::Default < Thor
  desc 'cop', 'Execute rubocop'
  def cop
    exec 'bundle exec rubocop --display-cop-names'
  end
end
