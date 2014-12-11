require 'fiji/compressor'
require 'fiji/client'
require 'fiji/ring'
require 'fiji/server'
require 'fiji/socket'
require 'fiji/version'
require 'fiji/options'
require 'fiji/railtie' if defined?(::Rails::Railtie)

module fiji
  # generic error
  class fijiError < RuntimeError; end
  # socket/server communication error
  class NetworkError < fijiError; end
  # no server available/alive error
  class RingError < fijiError; end
  # application error in marshalling serialization
  class MarshalError < fijiError; end
  # application error in marshalling deserialization or decompression
  class UnmarshalError < fijiError; end

  def self.logger
    @logger ||= (rails_logger || default_logger)
  end

  def self.rails_logger
    (defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger) ||
    (defined?(RAILS_DEFAULT_LOGGER) && RAILS_DEFAULT_LOGGER.respond_to?(:debug) && RAILS_DEFAULT_LOGGER)
  end

  def self.default_logger
    require 'logger'
    l = Logger.new(STDOUT)
    l.level = Logger::INFO
    l
  end

  def self.logger=(logger)
    @logger = logger
  end

end

if defined?(RAILS_VERSION) && RAILS_VERSION < '3'
  raise fiji::fijiError, "fiji #{fiji::VERSION} does not support Rails version < 3.0"
end
