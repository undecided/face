# frozen_string_literal: true

require 'typhoeus'
require_relative '../lib/structured_api/structured_apiable'
Dir['lib/**/*.rb'].each { |file| require_relative "../#{file}" }

module StructuredApi
end
