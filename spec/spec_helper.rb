require 'amazing_print'

require_relative '../lib/class-cattr'

class Object
  def rr data
    puts '- start: %s - %s' % [data.inspect, caller[0].sub(__dir__+'/', '')]
    ap data
    puts '- end'
  end
end

# basic config
RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :json, CustomFormatterClass
end
