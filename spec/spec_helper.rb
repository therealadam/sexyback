require 'sexyback'
require 'cassandra/mock'

RSpec.configure do

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
