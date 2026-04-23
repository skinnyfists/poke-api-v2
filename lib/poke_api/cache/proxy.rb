module PokeApi
  module Cache
    # Sits in front of the actual store and handles cache key/alias generation and store interaction
    class Proxy
      PATH_REGEX = %r{(?<=\/)[^\/?]+(?=\?|\/?$)}.freeze

      def self.fetch(url, &block)
        new(url, block).fetch
      end

      def initialize(url, block)
        @url = url
        @key = "poke_api/#{url}"
        @block = block
        @store = PokeApi.config.cache_store
      end

      def fetch
        read_cache || generate_and_cache_data
      end

      private

      attr_reader :data, :url, :store, :key

      def read_cache
        store.read(key) || read_from_alias
      end

      def read_from_alias
        alt_key = store.read(alias_key_for(url))
        store.read(alt_key) if alt_key
      end

      def alias_key_for(arg)
        "poke_api/alias/#{arg}"
      end

      def generate_and_cache_data
        @data = @block.call
        write_data
        write_alias if data_is_aliasable?
        data
      end

      def write_data
        store.write(key, data)
      end

      def data_is_aliasable?
        data[:id] && data[:name]
      end

      def write_alias
        store.write(alias_key_for(alternative_url), key)
      end

      def alternative_url
        @alternative_url ||= begin
          name, id = data.slice(:name, :id).values.map(&:to_s).map(&:downcase)

          path = url[PATH_REGEX]
          alternative_path = path == name ? id : name
          url.sub(PATH_REGEX, alternative_path)
        end
      end
    end
  end
end
