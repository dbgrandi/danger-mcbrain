require 'redis'

module Danger
  # Let's give Danger the ability to remember things in between runs. By
  # connecting her up to Redis, we have a simple key/value store where
  # we can keep stats and evaluate over time. This could be useful for
  # tracking the number of tests, author stats, or whatever else you want
  # to be able to ask Danger questions about the next time she checks your PR.
  #
  # @example Keep track of code coverage trends
  #
  #          last_cov = brain[:pr-1923][:code_cov_percent]
  #          if last_cov > code_cov
  #            warn "Coverage went from #{last_cov} to #{code_cov}"
  #          end
  #          brain[:pr-1924] = { :code_cov_percent => code_cov }
  #
  # @see  https://github.com/dbgrandi/danger-mcbrain
  # @tags persistance
  #
  class DangerMcBrain < Plugin
    def self.instance_name
      'brain'
    end

    # An attribute that contains a string that will be used
    # to prefix keys. If this is not set, a namespace prefix
    # will be created based on some info from the Dangerfile.
    # To set a globally available key, set this to "".
    #
    # @return [String]
    attr_accessor :namespace

    # Call from your Dangerfile *before* using DangerBrain to connect to
    # a redis server. May throw a `Redis::CannotConnectError` if unable
    # to connect. Any `options` you pass into this will be passed directly
    # to the `Redis` client.
    #
    def connect(options = {})
      @redis = Redis.new(options)
      @redis.client.connect
    end

    # Use to get a value out of DangerBrain. If you have set a namespace
    # it will be prefixed to your key with a `:`. Returns the value
    # associated with that key, or nil if it does not exist.
    #
    # @return [Object]
    def [](key)
      @redis[real_key(key)]
    end

    # Use to se a value in DangerBrain. If you have set a namespace, it
    # will be prefixed to your key with a ':'. Returns the value that
    # was passed in.
    #
    # @return [Object]
    def []=(key, value)
      @redis[real_key(key)] = value
    end

    private

    def real_key(key)
      return key if @namespace.nil? || namespace.empty?
      @namespace + ':' + key
    end
  end
end
