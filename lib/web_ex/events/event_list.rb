module WebEx
  module Events
    class EventList
      include Enumerable
    
      def initialize(*events)
        @events = events.flatten
      end
    
      def length
        @events.length
      end
    
      def each(&block)
        @events.each(&block)
      end
    
      def last
        @events.last
      end
    
      def empty?
        @events.empty?
      end
    
      def to_json
        JSON.dump(@events)
      end
    end
  end
end