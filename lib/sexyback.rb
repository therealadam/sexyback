require 'active_support/core_ext/module'
require 'simple_uuid'
require 'cassandra'

module Sexyback

  mattr_accessor :connection
  mattr_accessor :column_family

  class Hash

    attr_accessor :row_key

    def initialize
      @value = {}
    end

    def self.from_hash(row_key, hsh)
      new.tap do |h|
        h.row_key = row_key
        hsh.each do |(k, v)|
          h[k] = v
        end
      end
    end

    def []=(key, value)
      connection.insert(cf, row_key, {key => value})
      @value[key] = value
    end

    def [](key)
      value = connection.get_columns(cf, row_key, key).first
      @value[key] = value
    end

    def connection
      Sexyback.connection # HAX
    end

    def cf
      Sexyback.column_family # HAX
    end

  end

end
