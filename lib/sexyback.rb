require 'simple_uuid'
require 'cassandra'

module Sexyback

  autoload :Connection, 'sexyback/connection'

  autoload :Hash, 'sexyback/hash'
  autoload :Lock, 'sexyback/lock'
  autoload :Set, 'sexyback/set'

end
