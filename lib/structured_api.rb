# frozen_string_literal: true

require 'typhoeus'
require_relative '../lib/structured_api/structured_apiable'
Dir[File.join(File.dirname(__FILE__), '**/*.rb')].each do |file|
  file = file.sub(File.dirname(__FILE__), '')
  require_relative "./#{file}"
end

module StructuredApi
end
