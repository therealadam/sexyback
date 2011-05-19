require 'active_support/core_ext/class'
require 'active_support/concern'

# FIXME: global data here, bleh
module Sexyback::Connection
  extend ActiveSupport::Concern

  included do
    cattr_accessor :connection
    cattr_accessor :column_family

    alias :cf :column_family
  end

end

