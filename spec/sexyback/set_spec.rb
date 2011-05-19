require 'spec_helper'

describe Sexyback::Set do

  before do
    Sexyback::Set.connection = Cassandra::Mock.new('Sexyback', schema)
    Sexyback::Set.column_family = :Set
    subject.row_key = 'people'
  end

  let(:connection) { subject.connection }

  context "#add" do

    it 'adds a value to a set' do
      subject.add('bob')
      connection.get(:Set, 'people').should eq({'bob' => ''})
    end

  end

  context "#length" do

    it 'returns the number of items in the set' do
      subject.add('alice')
      subject.add('bob')
      subject.add('charlie')
      subject.length.should eq(3)
    end

  end

  context "#smembers" do

    it 'fetches all members of the set' do
      subject.add('alice')
      subject.add('bob')
      subject.add('charlie')
      subject.members.should eq(%w{alice bob charlie})
    end

  end

  context "#delete" do

    it 'removes a value from the set' do
      subject.add('alice')
      subject.delete('alice')
      subject.members.should eq([])
    end

  end

  context "#union" do

    it 'adds two sets and returns each unique values' do
      left = Sexyback::Set.new
      left.row_key = 'friends:aaron'
      left.add('alice')
      left.add('bob')

      right = Sexyback::Set.new
      right.row_key = 'friends:alice'
      right.add('bob')
      right.add('charlie')

      left.union(right).should eq(%w{alice charlie bob})
    end

  end

  context '#difference' do

    it 'subtracts two sets and returns values not present in self' do
      left = Sexyback::Set.new
      left.row_key = 'friends:aaron'
      left.add('alice')
      left.add('bob')

      right = Sexyback::Set.new
      right.row_key = 'friends:alice'
      right.add('bob')
      right.add('charlie')

      left.difference(right).should eq(%w{alice})
    end

  end

  context '#intersection' do

    it 'joins two sets and returns values present in both' do
      left = Sexyback::Set.new
      left.row_key = 'friends:aaron'
      left.add('alice')
      left.add('bob')

      right = Sexyback::Set.new
      right.row_key = 'friends:alice'
      right.add('bob')
      right.add('charlie')

      left.intersection(right).should eq(%w{bob})
    end

  end

  context '#is_member?' do

    it 'returns true if the value is present in the set' do
      subject.add('alice')
      subject.is_member?('alice').should be_true
    end

  end

  context '#random' do

    it 'returns a random member of the set' do
      subject.add('alice')
      subject.random.should eq('alice')
    end

  end

  # TODO: smove sinterstore spop sunionstore sdiffstore

end
