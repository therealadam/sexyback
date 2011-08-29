require 'spec_helper'

describe Sexyback::List do

  before { Sexyback::List.connection = Cassandra::Mock.new('Sexyback', schema) }
  subject { Sexyback::List.new(:List, 'the_roots') }
  let(:the_roots) { %w{ahmir tariq kamal james kirk frank damon owen} }

  describe "#add" do

    it "records an entry for the added object" do
      the_roots.each { |m| subject.add(m) }
      subject.to_a.should eq(the_roots)
    end

  end

  describe "#delete" do

    it "records an entry for the removed object" do
      the_roots.each { |m| subject.add(m) }
      subject.delete("owen") # Sorry, Owen

      subject.to_a.should_not include("owen")
    end

  end

  describe "#include?"

  describe "#compact"

end

