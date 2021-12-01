# frozen_string_literal: true

require 'typhoeus'
require_relative '../lib/face/faceable'
Dir['lib/**/*.rb'].each { |file| require_relative "../#{file}" }

module Face
end
