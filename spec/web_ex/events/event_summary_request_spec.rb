require 'spec_helper'
require 'fakeweb'

describe EventSummaryRequest do
  def fixture_path(name)
    File.expand_path("../../../fixtures/#{name}", __FILE__)
  end
  
  context "with a start date of a day ago and end date in a weeks' time" do
    let(:one_second) { 1 }
    let(:one_day_ago) { Time.now - (24 * 60 * 60) }
    let(:seven_days_from_now) { Time.now + (7 * 24 * 60 * 60) }

    let(:req) { EventSummaryRequest.new(start_date: one_day_ago, end_date: seven_days_from_now) }
  
    describe "#start_date" do
      subject { req.start_date }
      it { should be_within(one_second).of(one_day_ago) }
    end
  
    describe "#end_date" do
      subject { req.end_date }
      it { should be_within(one_second).of(seven_days_from_now) }
    end
  end
  
  describe "#payload" do
    let(:req)  { EventSummaryRequest.new }
    let(:xml) { Nokogiri::XML(req.payload) }
        
    describe "<?xml ?> processing instruction" do
      subject { xml.at_xpath('/processing-instruction("xml")').content }
      it { should include("UTF-8") }  
    end
    
    describe "namespaces" do
      let(:namespaces) { xml.collect_namespaces }
      it { namespaces.should have_key('xmlns:xsi') }
    end
    
    describe "security context" do    
      before :each do
        Configuration.stub(
          site_name: "wafflehut",
          site_id: "12345",
          username: "bobwaffles",
          password: "maplesyrup",
          partner_id: "p4rtn3r"
        )
      end
    
      let(:security_context) { xml.at_xpath('/message/header/securityContext') }
      it { security_context.at_xpath('./webExID').content.should == "bobwaffles" }
      it { security_context.at_xpath('./password').content.should == "maplesyrup" }
      it { security_context.at_xpath('./siteID').content.should == "12345" }
      it { security_context.at_xpath('./partnerID').content.should == "p4rtn3r" }
    end
    
    describe "body content" do
      let(:body_content) { xml.at_xpath('/message/body/bodyContent') }
      it { body_content['xsi:type'].should include('LstsummaryEvent') }
      it { body_content.at_xpath('./listControl/startFrom').should_not be_nil }
      it { body_content.at_xpath('./order').should_not be_nil }
      it { body_content.at_xpath('./dateScope').should_not be_nil }
    end
    
    context "with start and end dates in a time zone" do
      before :each do
        midday_pancake_tuesday = Time.new(2014, 3, 4, 12, 0, 0, "+02:00")
        three_thirty_pm_pancake_tuesday = Time.new(2014, 3, 4, 15, 30, 0, "+02:00")
        req.stub(start_date: midday_pancake_tuesday, end_date: three_thirty_pm_pancake_tuesday)
      end
      
      describe "date scope" do
        let(:date_scope) { xml.at_xpath('/message/body/bodyContent/dateScope') }
        
        it "formats dates appropriately and in UTC time" do
          date_scope.at_xpath('./startDateStart').content.should == "03/04/2014 10:00:00"
          date_scope.at_xpath('./endDateEnd').content.should == "03/04/2014 13:30:00"
        end
        
        it "uses the UTC time zone ID" do
          date_scope.at_xpath('./timeZoneID').content.should == "21"
        end
      end
    end
  end
  
  describe "#find_events!" do
    let(:req) { EventSummaryRequest.new }
      
    before :each do
      Configuration.stub(xml_service_url: "https://webex-api.example.com/service")
      FakeWeb.register_uri(:post, "https://webex-api.example.com/service", body: response_body)
      req.stub(payload: "XML")
    end
      
    context "when the server responds with events" do
      let(:response_body) { fixture_path("responses/webex_events.xml") }
      
      it "creates a new event using from each event node" do
        Event.should_receive(:from_xml).exactly(13).times
        req.find_events!
      end
      
      it "returns the events in an event list" do
        events = req.find_events!
        events.should be_a(EventList)
        events.length.should == 13
        events.first.name.should == "Baking Basics"
        events.last.name.should == "Baking Finale"
      end
    end
    
    context "when the server responds without events" do
      let(:response_body) { fixture_path("responses/webex_events_no_results.xml") }
      
      it "returns an empty list" do
        events = req.find_events!
        events.should be_a(EventList)
        events.should be_empty        
      end
    end
    
    context "when the server responds with an authentication error" do
      let(:response_body) { fixture_path("responses/webex_events_auth_error.xml") }
      
      it "raises an error with the server's reason for the error" do
        -> {
          req.find_events!
        }.should raise_error { |error|
          error.message.should include('Corresponding User not found')
        }
      end
    end
  end
end