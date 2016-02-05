#!/usr/bin/env bash

gem uninstall -aIx elements_of_interest
gem build elements_of_interest.gemspec
gem install --local --no-rdoc --no-ri elements_of_interest-0.0.0.gem
