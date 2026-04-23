RSpec.describe PokeApi::Configuration do
  before { PokeApi.instance_variable_set(:@config, nil) }

  describe 'PokeApi.config' do
    it 'returns a Configuration instance' do
      expect(PokeApi.config).to be_a(PokeApi::Configuration)
    end

    it 'defaults cache_store to a MemoryStore' do
      expect(PokeApi.config.cache_store).to be_a(PokeApi::Cache::MemoryStore)
    end
  end

  describe 'PokeApi.configure' do
    it 'allows setting a custom cache store' do
      custom_store = PokeApi::Cache::MemoryStore.new
      PokeApi.configure { |c| c.cache_store = custom_store }
      expect(PokeApi.config.cache_store).to be(custom_store)
    end
  end
end
