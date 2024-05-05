# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Initialize a logger sending to standard output.
Rails.logger = Logger.new($stdout)
