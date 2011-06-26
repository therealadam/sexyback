require 'active_support/callbacks'

class Sexyback::LockAlreadyTaken < StandardError; end

class Sexyback::Lock
  include Sexyback::Connection
  include ActiveSupport::Callbacks

  define_callbacks :check_lock

  DEFAULT_TTL = 5 # seconds

  def token
    "#{Process.pid}/#{Thread.object_id}"
  end

  def lock(object_key)
    check_lock(object_key)
    acquire_lock(object_key)
    verify_lock(object_key)
  end

  def acquire_lock(object_key)
    lock_value = Cassandra::OrderedHash.new
    lock_value.[]=(token, '', (Time.now + DEFAULT_TTL).to_i)
    connection.insert(cf, object_key, lock_value)
  end

  def check_lock(object_key)
    run_callbacks :check_lock do
      lock_value = connection.get(cf, object_key)
      raise Sexyback::LockAlreadyTaken.new unless lock_value.empty? || lock_value == {token => ''}
    end
  end

  def verify_lock(object_key)
    lock_value = connection.get(cf, object_key)
    raise Sexyback::LockAlreadyTaken.new unless lock_value == {token => ''}
  end

  def touch(object_key)
    lock_value = connection.get(cf, object_key)
    raise Sexyback::LockAlreadyTaken.new unless lock_value == {token => ''}
    lock_value.[]=(token, '', Time.now.to_i + DEFAULT_TTL)
    connection.insert(cf, object_key, lock_value)
  end

  def release(object_key)
    lock_value = connection.get(cf, object_key)
    raise Sexyback::LockAlreadyTaken.new unless lock_value == {token => ''}
    connection.remove(cf, object_key)
  end

end
