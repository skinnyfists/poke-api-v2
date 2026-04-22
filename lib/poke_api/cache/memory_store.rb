module PokeApi
  module Cache
    class MemoryStore
      def initialize
        @store = {}
        @mutex = Mutex.new
      end

      def read(key)
        @mutex.synchronize { @store[key] }
      end

      def write(key, value)
        @mutex.synchronize { @store[key] = value }
      end

      def fetch(key)
        @mutex.synchronize { @store[key] ||= yield }
      end
    end
  end
end
