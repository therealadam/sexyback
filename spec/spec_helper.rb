require 'sexyback'
require 'cassandra/mock'

RSpec.configure do |config|

  config.before(:each, :db => true) do
    Sexyback::Lock.connection = Cassandra.new('Sexyback')
  end

  config.before(:each) do
    next unless Sexyback::Lock.connection.nil?
    Sexyback::Lock.connection = Cassandra::Mock.new('Sexyback', schema)
  end

  def schema
    {
      'Sexyback' => {
        'Hash' => {
          'comparator_type' => 'org.apache.cassandra.db.marshal.UTF8Type',
          'column_type' => 'Standard'
        },
        'Set' => {
          'comparator_type' => 'org.apache.cassandra.db.marshal.UTF8Type',
          'column_type' => 'Standard'
        },
        'Lock' => {
          'comparator_type' => 'org.apache.cassandra.db.marshal.UTF8Type',
          'column_type' => 'Standard'
        }
      }
    }
  end

end
