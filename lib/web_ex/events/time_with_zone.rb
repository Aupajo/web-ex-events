module WebEx
  module Events
    class TimeWithZone
      UTC_ZONE_ID = 21
    
      TIME_ZONE_MAPPINGS = {
         0 => "Pacific/Niue",
         1 => "Pacific/Apia",
         2 => "Pacific/Honolulu",
         3 => "America/Juneau ",
         4 => "America/Los_Angeles",
         5 => "America/Phoenixr",
         6 => "America/Denver",
         7 => "America/Chicago",
         8 => "America/Tegucigalpa",
         9 => "America/Regina",
        10 => "America/Bogota",
        11 => "America/New_York",
        12 => "America/Indiana/Indianapolis",
        13 => "America/Halifax",
        14 => "America/Caracas",
        15 => "America/St_Johns",
        16 => "America/Sao_Paulo",
        17 => "America/Argentina/Buenos_Aires",
        18 => "Atlantic/South_Georgia",
        19 => "Atlantic/Azores",
        20 => "Africa/Casablanca",
        21 => "Europe/London",
        22 => "Europe/Amsterdam",
        23 => "Europe/Paris",
        24 => "Europe/Paris",
        25 => "Europe/Berlin",
        26 => "Europe/Athens",
        27 => "Europe/Athens",
        28 => "Africa/Cairo",
        29 => "Africa/Johannesburg",
        30 => "Europe/Helsinki",
        31 => "Asia/Amman",
        32 => "Asia/Baghdad",
        33 => "Europe/Moscow",
        34 => "Africa/Nairobi",
        35 => "Asia/Tehran",
        36 => "Asia/Muscat",
        37 => "Asia/Baku",
        38 => "Asia/Kabul",
        39 => "Asia/Yekaterinburg",
        40 => "Asia/Karachi",
        41 => "Asia/Kolkata",
        42 => "Asia/Colombo",
        43 => "Asia/Almaty",
        44 => "Asia/Bangkok",
        45 => "Asia/Shanghai",
        46 => "Australia/Perth",
        47 => "Asia/Singapore",
        48 => "Asia/Taipei",
        49 => "Asia/Tokyo",
        50 => "Asia/Seoul",
        51 => "Asia/Yakutsk",
        52 => "Australia/Adelaide",
        53 => "Australia/Darwin",
        54 => "Australia/Brisbane",
        55 => "Australia/Sydney",
        56 => "Pacific/Guam",
        57 => "Australia/Hobart",
        58 => "Asia/Vladivostok",
        59 => "Asia/Magadan",
        60 => "Pacific/Auckland",
        61 => "Pacific/Fiji"
      }
    
      def initialize(date_string, timezone_id)
        @date_string = date_string
        @timezone_id = timezone_id.to_i
      end
    
      def to_datetime
        month, day, year, hour, minute, second = @date_string.split(/[\/ :]/).map(&:to_i)
        time_zone = TZInfo::Timezone.get(TIME_ZONE_MAPPINGS[@timezone_id])
        time_zone.local_to_utc DateTime.new(year, month, day, hour, minute, second)
      end
    end
  end
end