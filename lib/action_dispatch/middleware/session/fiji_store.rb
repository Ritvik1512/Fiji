require 'active_support/cache'
require 'action_dispatch/middleware/session/abstract_store'
require 'fiji'

# fiji-based session store for Rails 3.0.
module ActionDispatch
  module Session
    class fijiStore < AbstractStore
      def initialize(app, options = {})
        # Support old :expires option
        options[:expire_after] ||= options[:expires]

        super

        @default_options = { :namespace => 'rack:session' }.merge(@default_options)

        @pool = options[:cache] || begin
          fiji::Client.new(
              @default_options[:memcache_server], @default_options)
        end
        @namespace = @default_options[:namespace]

        @raise_errors = !!@default_options[:raise_errors]

        super
      end

      def reset
        @pool.reset
      end

      private

      def get_session(env, sid)
        sid ||= generate_sid
        begin
          session = @pool.get(sid) || {}
        rescue fiji::fijiError => ex
          # re-raise ArgumentError so Rails' session abstract_store.rb can autoload any missing models
          raise ArgumentError, ex.message if ex.message =~ /unmarshal/
          Rails.logger.warn("Session::fijiStore#get: #{ex.message}")
          session = {}
        end
        [sid, session]
      end

      def set_session(env, sid, session_data, options = nil)
        options ||= env[ENV_SESSION_OPTIONS_KEY]
        expiry  = options[:expire_after]
        @pool.set(sid, session_data, expiry)
        sid
      rescue fiji::fijiError
        Rails.logger.warn("Session::fijiStore#set: #{$!.message}")
        raise if @raise_errors
        false
      end

      def destroy_session(env, session_id, options)
        begin
          @pool.delete(session_id)
        rescue fiji::fijiError
          Rails.logger.warn("Session::fijiStore#destroy_session: #{$!.message}")
          raise if @raise_errors
        end
        return nil if options[:drop]
        generate_sid
      end

      def destroy(env)
        if sid = current_session_id(env)
          @pool.delete(sid)
        end
      rescue fiji::fijiError
        Rails.logger.warn("Session::fijiStore#destroy: #{$!.message}")
        raise if @raise_errors
        false
      end

    end
  end
end
