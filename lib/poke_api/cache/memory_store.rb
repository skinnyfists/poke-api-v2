module PokeApi
  module Cache
    # In-memory cache store implementation with basic read/write/fetch interface
    class MemoryStore
      def initialize
        @store = {}
      end

      def read(key)
        @store[key]
      end

      def write(key, value)
        @store[key] = value
      end

      def fetch(key)
        @store[key] ||= yield
      end
    end
  end
end
