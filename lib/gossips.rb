require_relative "gossips/configuration"
require_relative "gossips/search"
require_relative "gossips/version"
require_relative "gossips/models"
require_relative "gossips/concerns/taggable"

require 'byebug'
require 'securerandom'
require 'redis'

module Gossips
  class Error < StandardError; end
  class << self
    attr_reader :config

    def configure
      @config ||= Configuration.new
      yield(@config)
    end

    def redis
      @redis ||= Redis.new(url: config.redis.url)
    end
  end

  def taggable(options = {})
    Models.tagged << to_s

    class_attribute :_inherit_gossip
    self._inherit_gossip = options[:inherit]

    class_eval do
      include Concerns::Taggable
    end
  end
end

require 'active_model/callbacks'
ActiveModel::Callbacks.include(Gossips)

ActiveSupport.on_load(:active_record) do
  extend Gossips
end
