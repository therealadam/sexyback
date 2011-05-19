require 'sexyback'
require 'cassandra/mock'

RSpec.configure do

  def schema
    {
      'Sexyback' => {
        'Hash' => {
          'comparator_type' => 'org.apache.cassandra.db.marshal.UTF8Type',
          'column_type' => 'Standard'
        }
      }
    }
  end

end

describe Sexyback::Hash do

  before { Sexyback::Hash.connection = Cassandra::Mock.new('Sexyback', schema) }
  before { Sexyback::Hash.column_family = :Hash }
  before { subject.row_key = 'people' }

  context ".from_hash" do

    it 'creates a hash from a Ruby hash' do
      hsh = {'a' => 1, 'b' => 2}

      sb_hsh = Sexyback::Hash.from_hash('from_hash', hsh)
      sb_hsh['a'].should eq(1)
      sb_hsh['b'].should eq(2)
    end

  end

  context "get and set" do

    before { subject.row_key = 'people' }

    it 'add or update a key in the hash' do
      subject.set("alice", 'alice')
      subject.get('alice').should eq('alice')
    end

    it 'add or update a column' do
      subject.connection.insert(:Hash, 'people', {'wonk' => 'wonk'})
      subject.get('wonk').should eq('wonk')
    end

  end

  context '#has_key?' do

    it 'detects the presence of a key in the row' do
      subject['alice'] = 'alice'
      subject.has_key?('alice').should be_true
    end

  end

  context "#delete" do

    it 'removes a key from the hash' do
      subject['alice'] = 'alice'
      subject.delete('alice')
      subject.has_key?('alice').should be_false
    end

    it 'removes a column from the row' do
      subject.connection.insert(:Hash, 'people', {'wonk' => 'wonk'})
      subject.delete('wonk')
      subject.connection.get_columns(:Hash, 'people', 'wonk').should == [nil]
    end

  end

  context "#get_all" do

    it 'fetches all columns from the row' do
      subject['alice'] = 'alice'
      subject['bob'] = 'bob'
      subject.get_all.should eq({'alice' => 'alice', 'bob' => 'bob'})
    end

  end

  context "#keys" do

    it 'fetches all keys from the row' do
      subject['alice'] = 'alice'
      subject['bob'] = 'bob'
      subject.keys.should eq(['alice', 'bob'])
    end

  end

  context "#values" do

    it 'fetches all values from the row' do
      subject['alice'] = 'alice'
      subject['bob'] = 'bob'
      subject.values.should eq(['alice', 'bob'])
    end

  end

  context "#mset" do

    it 'updates multiple keys in one operation' do
      subject.mset('alice', 'alice', 'bob', 'bob')
      subject.connection.get_columns(:Hash, 'people', ['alice', 'bob']).should eq(['alice', 'bob'])
    end

  end

  context "#mget" do

    it 'fetches multiple keys in one operation' do
      subject.mset('alice', 'alice', 'bob', 'bob')
      subject.mget('alice', 'bob').should eq(['alice', 'bob'])
    end

  end

end
