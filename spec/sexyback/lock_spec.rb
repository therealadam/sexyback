require 'spec_helper'

describe Sexyback::Lock do

  before do
    Sexyback::Lock.column_family = :Lock
    Sexyback::Lock.connection.remove(:Lock, 'hash:people') # DRY move the key to a let
  end
  let(:connection) { subject.connection }

  context '#token' do

    it 'generates an identity for tracing lock ownership' do
      subject.token.should eq("#{Process.pid}/#{Thread.object_id}")
    end

  end

  context '#acquire' do

    it 'sets the lock if no lock is set' do
      subject.lock('hash:people')
      connection.get(:Lock, 'hash:people').should eq(subject.token => '')
    end

    it 'sets the TTL on a lock', :db => true do
      expire_at = Time.now.to_i + Sexyback::Lock::DEFAULT_TTL

      subject.lock('hash:people')
      lock_value = connection.get(:Lock, 'hash:people')
      lock_value.timestamps[subject.token].should be > expire_at
    end

    it 'touches the lock if the lock is already owned by this process', :db => true do
      subject.lock('hash:people')
      expires = connection.get(:Lock, 'hash:people').timestamps[subject.token]
      subject.lock('hash:people')
      connection.get(:Lock, 'hash:people').timestamps[subject.token].should be > expires
    end

    it 'raises an exception if the lock is already set' do
      connection.insert(subject.cf, 'hash:people', {'other' => ''})
      expect { subject.lock('hash:people') }.to raise_exception(Sexyback::LockAlreadyTaken)
    end

    it 'raises an exception if the lock was not actually acquired' do
      cf = subject.cf
      callback = lambda { connection.insert(cf, 'hash:people', {'other' => ''}) }
      subject.class.set_callback :check_lock, :after, callback

      expect { subject.lock('hash:people') }.to raise_exception(Sexyback::LockAlreadyTaken)

      subject.class.reset_callbacks(:check_lock) # Cleanup
    end

  end

  context '#touch' do

    it 'updates the TTL on the lock', :db => true do
      subject.lock('hash:people')
      lock_value = connection.get(:Lock, 'hash:people')
      subject.touch('hash:people')
      new_value = connection.get(:Lock, 'hash:people')
      new_value.timestamps[subject.token].should be > lock_value.timestamps[subject.token]
    end

    it 'raises an exception if another process owns the lock' do
      connection.insert(subject.cf, 'hash:people', {'other' => ''})
      expect { subject.touch('hash:people') }.to raise_exception(Sexyback::LockAlreadyTaken)
    end

  end

  context '#release' do

    it 'removes the lock if it is owned by the current process' do
      connection.remove(:Lock, 'hash:people') # HAX
      subject.lock('hash:people')
      subject.release('hash:people')
      connection.get(:Lock, 'hash:people').should eq({})
    end

    it 'raises an exception if another process owns the lock' do
      connection.insert(subject.cf, 'hash:people', {'other' => ''})
      expect { subject.release('hash:people') }.to raise_exception(Sexyback::LockAlreadyTaken)
    end

  end

end
