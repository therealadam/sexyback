class Sexyback::List
  include Sexyback::Connection

  attr_accessor :cf, :key

  def initialize(cf, key)
    @cf = cf
    @key = key
  end

  def add(obj)
    connection.insert(cf, key, addition_for(obj))
  end

  def delete(obj)
    connection.insert(cf, key, removal_for(obj))
  end

  def to_a
    connection.get(cf, key).inject([]) do |ary, (timestamp, entry)|
      case entry
      when /^\+/
        ary << entry.slice(1..-1)
      when /^-/
        ary.delete(entry.slice(1..-1))
      end
      ary
    end
  end

  def addition_for(obj)
    {timestamp => "+" + obj}
  end

  def removal_for(obj)
    {timestamp => "-" + obj}
  end

  def timestamp
    t = Time.now.utc
    t.tv_sec * 10_000_000 + t.tv_usec
  end

end

