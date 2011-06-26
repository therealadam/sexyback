require 'spec_helper'

describe Sexyback::Lock do

  before { Sexyback::Lock.column_family = :Lock }
  after { Sexyback::Lock.connection.remove(:Lock, lock_key) }

  let(:lock_key) { 'hash:people' }
  let(:connection) { subject.connection }

  context '#token' do

    it 'generates an identity for tracing lock ownership' do
      subject.token.should eq("#{Process.pid}/#{Thread.object_id}")
    end

  end

  context '#acquire' do

    it 'sets the lock if no lock is set' do
      subject.lock(lock_key)
      connection.get(:Lock, lock_key).should eq(subject.token => '')
    end

    it 'sets the TTL on a lock', :db => true do
      expire_at = Time.now.to_i + Sexyback::Lock::DEFAULT_TTL

      subject.lock(lock_key)
      lock_value = connection.get(:Lock, lock_key)
      lock_value.timestamps[subject.token].should be > expire_at
    end

    it 'touches the lock if the lock is already owned by this process', :db => true do
      subject.lock(lock_key)
      expires = connection.get(:Lock, lock_key).timestamps[subject.token]
      subject.lock(lock_key)
      connection.get(:Lock, lock_key).timestamps[subject.token].should be > expires
    end

    it 'raises an exception if the lock is already set' do
      connection.insert(subject.cf, lock_key, {'other' => ''})
      expect { subject.lock(lock_key) }.to raise_exception(Sexyback::LockAlreadyTaken)
    end

    it 'raises an exception if the lock was not actually acquired' do
      cf = subject.cf
      l = lock_key # Need to grab the value of lock_key for the lambda
      callback = lambda { connection.insert(cf, l, {'other' => ''}) }
      subject.class.set_callback :check_lock, :after, callback

      expect { subject.lock(lock_key) }.to raise_exception(Sexyback::LockAlreadyTaken)

      subject.class.reset_callbacks(:check_lock) # Cleanup
    end

  end

  context '#touch' do

    it 'updates the TTL on the lock', :db => true do
      subject.lock(lock_key)
      lock_value = connection.get(:Lock, lock_key)
      subject.touch(lock_key)
      new_value = connection.get(:Lock, lock_key)
      new_value.timestamps[subject.token].should be > lock_value.timestamps[subject.token]
    end

    it 'raises an exception if another process owns the lock' do
      connection.insert(subject.cf, lock_key, {'other' => ''})
      expect { subject.touch(lock_key) }.to raise_exception(Sexyback::LockAlreadyTaken)
    end

  end

  context '#release' do

    it 'removes the lock if it is owned by the current process' do
      connection.remove(:Lock, lock_key) # HAX
      subject.lock(lock_key)
      subject.release(lock_key)
      connection.get(:Lock, lock_key).should eq({})
    end

    it 'raises an exception if another process owns the lock' do
      connection.insert(subject.cf, lock_key, {'other' => ''})
      expect { subject.release(lock_key) }.to raise_exception(Sexyback::LockAlreadyTaken)
    end

  end

end
