require 'thread'
require 'monitor'

module fiji

  # Make fiji threadsafe by using a lock around all
  # public server methods.
  #
  # fiji::Server.extend(fiji::Threadsafe)
  #
  module Threadsafe
    def self.extended(obj)
      obj.init_threadsafe
    end

    def request(op, *args)
      @lock.synchronize do
        super
      end
    end

    def alive?
      @lock.synchronize do
        super
      end
    end

    def close
      @lock.synchronize do
        super
      end
    end

    def lock!
      @lock.mon_enter
    end

    def unlock!
      @lock.mon_exit
    end

    def init_threadsafe
      @lock = Monitor.new
    end
  end
end
