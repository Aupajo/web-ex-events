require 'spec_helper'

describe EventList do
  let(:event_a) { stub }
  let(:event_b) { stub }
  let(:event_c) { stub }
  
  describe "#each" do
    let(:event_list) { EventList.new(event_a, event_b, event_c) }
    
    it "iterates over each event" do
      captured_events = []
      event_list.each { |event| captured_events << event }
      captured_events.should == [event_a, event_b, event_c]
    end
  end
  
  describe "#to_json" do
    let(:event_list) { EventList.new(event_a, event_b) }
    
    before :each do
      event_a.stub(to_json: '{ "event": "a" }')
      event_b.stub(to_json: '{ "event": "b" }')
    end
    
    it "returns a JSON representation of all events" do
      JSON.parse(event_list.to_json).should == [{ 'event' => 'a' }, { 'event' => 'b' }]
    end
  end
  
  describe "#length" do
    it "returns the number of events" do
      EventList.new(event_a, event_b).length.should == 2
      EventList.new(event_a, event_b, event_c).length.should == 3
    end
  end
  
  context "with three events" do
    let(:event_list) { EventList.new(event_a, event_b, event_c) }
    
    describe "#first and #last" do
      it { event_list.first.should == event_a }
      it { event_list.last.should == event_c }
    end
  end
  
  context "with no events" do
    subject {  EventList.new }
    it { should be_empty }
  end
  
  context "with at least one event" do
    subject { EventList.new(event_a) }
    it { should_not be_empty }
  end
  
end