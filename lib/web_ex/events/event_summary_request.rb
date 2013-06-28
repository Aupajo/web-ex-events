module WebEx
  module Events
    class EventSummaryRequest
      WEBEX_EMPTY_RESULTS_EXCEPTION_ID = "000015"
    
      attr_accessor :start_date, :end_date
    
      def initialize(options = {})
        @start_date, @end_date = options[:start_date], options[:end_date]
      end
    
      def find_events!
        events = xml_response.xpath('//event').map do |node|
          Event.from_xml(node.to_xml)
        end
      
        EventList.new(events)
      end
    
      def payload
        <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <header>
              <securityContext>
                <webExID>#{Configuration.username}</webExID>
                <password>#{Configuration.password}</password>
                <siteID>#{Configuration.site_id}</siteID>
                <partnerID>#{Configuration.partner_id}</partnerID>
              </securityContext>
            </header>
            <body>
              <bodyContent xsi:type="java:com.webex.service.binding.event.LstsummaryEvent">
                <listControl>
                  <startFrom/>
                </listControl>
                <order>
                  <orderBy>STARTTIME</orderBy>
                </order>
                <dateScope>
                  <startDateStart>#{formatted_date start_date}</startDateStart>
                  <endDateEnd>#{formatted_date end_date}</endDateEnd>
                  <timeZoneID>#{TimeWithZone::UTC_ZONE_ID}</timeZoneID>
                </dateScope>
              </bodyContent>
            </body>
          </message>
        XML
      end
    
      private
    
      def response
        @response ||= HTTParty.post(Configuration.xml_service_url, body: payload)
      end
    
      def xml_response
        @xml_response ||= begin
          xml = Nokogiri::XML(response.body)
          webex_exception = xml.at_xpath('//serv:exceptionID')
              
          if webex_exception && webex_exception.content != WEBEX_EMPTY_RESULTS_EXCEPTION_ID
            raise "WebEx Error: #{xml.at_xpath('//serv:reason').content}" 
          end
        
          xml.remove_namespaces!
        end
      end
    
      def formatted_date(date)
        date.utc.strftime('%m/%d/%Y %H:%M:%S') if date
      end
    end
  end
end