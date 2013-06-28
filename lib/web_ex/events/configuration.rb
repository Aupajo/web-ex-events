module WebEx
  module Events
    class Configuration
    
      %w( site_name site_id username password partner_id ).each do |name|
        define_singleton_method(name) { ENV["WEBEX_#{name.upcase}"] }
      end
    
      def self.xml_service_url
        "https://#{site_name}.webex.com/WBXService/XMLService"
      end
    
    end
  end
end