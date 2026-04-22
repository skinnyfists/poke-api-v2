RSpec.describe PokeApi::Cache::MemoryStore do
  subject(:store) { described_class.new }

  describe '#read' do
    it 'returns nil on miss' do
      expect(store.read('missing')).to be_nil
    end

    it 'returns stored value on hit' do
      subject.instance_variable_set(:@store, { 'key' => 'value' })
      expect(store.read('key')).to eq('value')
    end
  end

  describe '#write' do
    it 'stores a value in the underlying hash' do
      store.write('pokemon/1', { id: 1, name: 'bulbasaur' })
      expect(store.instance_variable_get(:@store)['pokemon/1']).to eq({ id: 1, name: 'bulbasaur' })
    end
  end

  describe '#fetch' do
    it 'calls the block and stores the result on miss' do
      call_count = 0
      result = store.fetch('key') { call_count += 1; 'value' }
      expect(result).to eq('value')
      expect(call_count).to eq(1)
    end

    it 'returns cached value without calling block on hit' do
      store.fetch('key') { 'block called' }
      result = store.fetch('key') { 'block not called' }
      expect(result).to eq('block called')
    end
  end
end
