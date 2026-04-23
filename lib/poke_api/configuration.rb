module PokeApi
  # Holds gem-wide configuration
  class Configuration
    attr_accessor :cache_store

    def initialize
      @cache_store = Cache::MemoryStore.new
    end
  end
end
