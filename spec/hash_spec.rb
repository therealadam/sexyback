require 'sexyback'
require 'cassandra/mock'

describe Sexyback::Hash do

  before { Sexyback.connection = Cassandra::Mock.new('Sexyback', schema) }
  before { Sexyback.column_family = :Hash }
  before { subject.row_key = 'people' }

  context ".from_hash" do

    it 'creates a hash from a Ruby hash' do
      hsh = {'a' => 1, 'b' => 2}

      sb_hsh = Sexyback::Hash.from_hash('from_hash', hsh)
      sb_hsh['a'].should eq(1)
      sb_hsh['b'].should eq(2)
    end

  end

  context "subscript operators" do

    before { subject.row_key = 'people' }

    it 'adds or updates a key in the hash' do
      subject["alice"] = 'alice' 
      subject['alice'].should eq('alice')
    end

    it 'adds or updates a column' do
      subject.connection.insert(:Hash, 'people', {'wonk' => 'wonk'})
      subject['wonk'].should eq('wonk')
    end

  end

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
