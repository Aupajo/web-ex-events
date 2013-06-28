require "spec_helper"

describe Event do
  let(:valid_attributes) {
    {
      name: "Cupcake Giveaway",
      start_date: DateTime.now,
      end_date: DateTime.now + 3600,
      key: "12345",
      description: "Free cupcakes!",
      duration: 60
    }
  }
  
  let(:event) { Event.new(valid_attributes) }
  
  it "can has accessors for valid attributes" do
    valid_attributes.each do |name, value|
      event.send(name).should == value
    end
  end
  
  describe "#to_json" do
    let(:json) { JSON.parse(event.to_json) }
    
    it "contains all the valid attributes" do
      json["name"].should == "Cupcake Giveaway"
      json["start_date"].inspect.should == JSON.dump(DateTime.now)
      json["end_date"].inspect.should == JSON.dump(DateTime.now + 3600)
      json["key"].should == "12345"
      json["duration"].should == 60
      json["description"].should == "Free cupcakes!"
    end
  end
  
  describe ".from_xml" do
    let(:xml) {
      <<-XML
        <event>
          <sessionKey>662050914</sessionKey>
          <sessionName>NE Utilities - Transition Webinar Navtrak to Fleet</sessionName>
          <sessionType>220</sessionType>
          <hostWebExID>bakery</hostWebExID>
          <startDate>04/30/2013 05:00:00</startDate>
          <endDate>04/30/2013 06:30:00</endDate>
          <timeZoneID>4</timeZoneID>
          <duration>90</duration>
          <description>During this webinar you will be trained on the bakery Fleet application.</description>
          <status>NOT_INPROGRESS</status>
          <panelists></panelists>
          <listStatus>UNLISTED</listStatus>
        </event>
      XML
    }
    
    let(:parsed_event) { Event.from_xml(xml) }
    
    it "can parse an event" do
      parsed_event.name.should == "NE Utilities - Transition Webinar Navtrak to Fleet"
      parsed_event.key.should == "662050914"
      parsed_event.duration.should == 90
      parsed_event.description.should == "During this webinar you will be trained on the bakery Fleet application."
    end
    
    context "with a timezone not in daylight savings" do
      let(:xml) {
        <<-XML
          <event>
            <startDate>02/15/2013 05:00:00</startDate>
            <endDate>02/15/2013 06:30:00</endDate>
            <timeZoneID>4</timeZoneID>
          </event>
        XML
      }
      
      it "parses the date correctly" do
        parsed_event.start_date.should == DateTime.new(2013, 2, 15, 5, 0, 0, "-08:00")
        parsed_event.end_date.should == DateTime.new(2013, 2, 15, 6, 30, 0, "-08:00")
      end
    end
    
    context "with a timezone inside daylight savings" do
      let(:xml) {
        <<-XML
          <event>
            <startDate>04/30/2013 05:00:00</startDate>
            <endDate>04/30/2013 06:30:00</endDate>
            <timeZoneID>4</timeZoneID>
          </event>
        XML
      }
      
      it "corrects for daylight savings" do
        parsed_event.start_date.should == DateTime.new(2013, 4, 30, 5, 0, 0, "-07:00")
        parsed_event.end_date.should == DateTime.new(2013, 4, 30, 6, 30, 0, "-07:00")
      end
    end
  end
  
  describe ".fetch" do
    it "creates a new event summary request using the time frame" do
      Timecop.freeze do
        request = stub(find_events!: "events")
        ten_days = 10 * 24 * 60 * 60

        EventSummaryRequest.should_receive(:new)
                                  .with(start_date: Time.now, end_date: Time.now + ten_days)
                                  .and_return(request)
        
        Event.fetch(ten_days).should == "events"
      end
    end
  end
end