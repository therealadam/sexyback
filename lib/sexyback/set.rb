class Sexyback::Set
  include Sexyback::Connection

  attr_accessor :row_key

  def add(value)
    # ALGORITHM better way to structure this?
    connection.insert(cf, row_key, {value => ''})
  end
  alias :sadd :add

  def length
    connection.count_columns(cf, row_key)
  end
  alias :scard :length

  def members
    connection.get(cf, row_key).keys
  end
  alias :smembers :members

  def delete(value)
    connection.remove(cf, row_key, value)
  end
  alias :srem :delete

  def union(other)
    l = Set.new(members)
    r = Set.new(other.members)
    l.union(r).to_a
  end
  alias :sunion :union

  def difference(other)
    l = Set.new(members)
    r = Set.new(other.members)
    l.difference(r).to_a
  end
  alias :sdiff :difference

  def intersection(other)
    l = Set.new(members)
    r = Set.new(other.members)
    l.intersection(r).to_a
  end
  alias :sinter :intersection

  def is_member?(value)
    connection.exists?(cf, row_key, value)
  end
  alias :smember :is_member?

  def random
    members[rand(members.length - 1)]
  end
  alias :srandmember :random

end
