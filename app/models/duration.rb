class Duration
  # Input format
  # hh:mm -- denotes hour and minutes
  # :mm  -- denotes minutes
  # 15 -- 15 hours
  # 24 -- 24 hours
  # .25 -- .25 hours == 15 minutes
  # 1.5 -- 1.5 hours == 1 hour 30 minutes

  # client format -- hh:mm
  # server format -- 2000-01-01 hh:mm:00 -UTC
  def initialize(duration)
    if duration.class==Time
      @duration = make_client_format(duration.hour,duration.min)
    else
      @duration = input_format_to_client_duration(duration)
    end
  end

  def is_zero_duration?
    '00:00' == @duration
  end

  def contains_nil?
    @duration.nil?
  end

  def client_duration
    @duration
  end
  # NOTE: an input of 24:00 gets converted to 2000-01-02 00:00:00
  def server_duration
    # TODO: MAJOR HACK!
    # The db can't store the year,month, day information
    # So when we try to store 24:00 hours it gets saved a 2000-01-01 00:00:00
    # Therefore, we use the 'seconds' field to record that we rolled over
    # Then, when we convert back from server format to client format we know
    # if the 00:00 represents 00:00 or 24:00
    # Better to find a better format to record duration..
    value = ('2000-01-01 ' + @duration).to_time(:utc)
    value.day == 2 ? value + 1.seconds : value
  end
  alias_method :to_time, :server_duration

  # input:string -- str in server format
  # client format is hh:mm
  def self.server_to_client_duration(input)
    input.strftime('%S') == '01' ? '24:00' : input.strftime('%H:%M')
  end

  # @return [Integer] duration in integer format (i.e. 1.5 for 1:30)
  def to_i
    to_time.day * 24 + to_time.hour + to_time.min/60.0
  end

  private
  # @param [String] input - an input strin
  # @return [Object] - nil if invalid string, "00:00" if blank or empty, client-side format hh:mm otherwise
  def input_format_to_client_duration(input)
    # check for empty values from the form input
    return '00:00' if(input.blank? or input =='0')

    if input =~ /\A(\d\d?)?:(\d\d)\z/
      # colon format (1:01, 08:15)
      result = make_client_format($1,$2)
    elsif input =~ /\A(\d{1,2})?(\.\d{1,3})\z/
      # decimal format (.25,1.5) etc)
      # NOTE, $2 matches with the "." in order to capture the fractional number (i.e. 0.xxx)
      result = make_client_format($1,$2.to_f*60)
    elsif input =~ /\A(\d{1,2})?\z/
      # integer format ( 15, 65)
      # TODO: Should this always treat the number as minutes?
      result = make_client_format($1,0)
    else
      # invalid input
      return nil
    end

    # Validation, check to make sure the hours and minutes are within range.
    m = /\A(\d\d):(\d\d)\z/.match(result)
    return nil if( m[1].to_i == 24 && m[2].to_i > 0) or ( m[1].to_i > 24 || m[2].to_i > 60)
    result
  end

# Function to create the client time format string.
# Ensure two places for hour and minutes 01:01
  def make_client_format(hr,min)
    hr = 0 if hr == nil
    min = 0 if min == nil
    format('%02d', hr.to_i).to_s + ':' + format('%02d',min.to_i).to_s
  end
end