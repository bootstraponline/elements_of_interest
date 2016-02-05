require 'rubygems'
require 'rspec'

require_relative '../lib/elements_of_interest'

RSpec.configure do |config|
  config.include ElementsOfInterest::Util
end
