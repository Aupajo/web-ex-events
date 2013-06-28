module WebEx
  module Events
    class Event
      attr_accessor :name, :start_date, :end_date, :key, :description, :duration
    
      def initialize(attributes = {})
        attributes.each do |k, v|
          send("#{k}=", v)
        end
      end
    
      def to_json(*args)
        JSON.dump(
          name: name,
          start_date: start_date,
          end_date: end_date,
          key: key,
          description: description,
          duration: duration
        )
      end
    
      def self.from_xml(xml)
        node = Nokogiri::XML(xml)
        element = node.xpath('event')
      
        self.new(
          name: element.xpath('sessionName').text,
          start_date: ::WebEx::Events::TimeWithZone.new(element.xpath('startDate').text, element.xpath('timeZoneID').text).to_datetime,
          end_date: ::WebEx::Events::TimeWithZone.new(element.xpath('endDate').text, element.xpath('timeZoneID').text).to_datetime,
          key: element.xpath('sessionKey').text,
          description: element.xpath('description').text,
          duration: element.xpath('duration').text.to_i
        )
      end
    
      def self.fetch(time_frame)
        request = EventSummaryRequest.new(start_date: Time.now, end_date: Time.now + time_frame)
        request.find_events!
      end
    end
  end
end