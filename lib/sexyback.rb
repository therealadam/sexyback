require 'active_support/core_ext/class'
require 'active_support/concern'

require 'simple_uuid'
require 'cassandra'

module Sexyback

  module Connection
    extend ActiveSupport::Concern

    included do
      cattr_accessor :connection
      cattr_accessor :column_family

      alias :cf :column_family
    end

  end

  class Hash
    include Sexyback::Connection

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

    def set(key, value)
      connection.insert(cf, row_key, {key => value})
      @value[key] = value
    end
    alias :[]= :set

    def get(key)
      value = connection.get_columns(cf, row_key, key).first
      @value[key] = value
    end
    alias :[] :get

    def has_key?(key)
      connection.exists?(cf, row_key, key)
    end
    alias :exists :has_key?

    def delete(key)
      connection.remove(cf, row_key, key)
    end
    alias :del :delete

    def to_hash
      connection.get(cf, row_key)
    end
    alias :get_all :to_hash

  end

end
