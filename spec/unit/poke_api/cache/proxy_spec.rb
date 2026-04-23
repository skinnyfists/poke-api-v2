RSpec.describe PokeApi::Cache::Proxy do
  before { PokeApi.instance_variable_set(:@config, nil) }

  let(:name_url) { 'https://pokeapi.co/api/v2/pokemon/bulbasaur' }
  let(:id_url)   { 'https://pokeapi.co/api/v2/pokemon/1' }
  let(:data)     { { id: 1, name: 'bulbasaur', url: name_url } }

  describe '.fetch' do
    it 'calls the provided block on a cache miss' do
      call_count = 0
      described_class.fetch(name_url) { call_count += 1; data }
      expect(call_count).to eq(1)
    end

    it 'returns the fetched data on a cache miss' do
      result = described_class.fetch(name_url) { data }
      expect(result).to eq(data)
    end

    it 'does not call the block on a cache hit' do
      described_class.fetch(name_url) { data }
      call_count = 0
      described_class.fetch(name_url) { call_count += 1; data }
      expect(call_count).to eq(0)
    end

    describe 'alias resolution' do
      it 'does not call the provided block when called with id after a name lookup' do
        described_class.fetch(name_url) { data }
        call_count = 0
        described_class.fetch(id_url) { call_count += 1 }
        expect(call_count).to eq(0)
      end

      it 'does not call the provided block when called with name after an id lookup' do
        described_class.fetch(id_url) { data }
        call_count = 0
        described_class.fetch(name_url) { call_count += 1 }
        expect(call_count).to eq(0)
      end

      it 'does not write an alias when response has no name' do
        described_class.fetch(id_url) { { id: 1, url: id_url } }
        expect(PokeApi.config.cache_store.read("poke_api/alias/#{name_url}")).to be_nil
      end
    end
  end
end
