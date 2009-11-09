require 'rexml/formatters/pretty'
require 'string_rtmize'
class MockHttp
  def initialize(response=nil)
    @response = response
    if !@response.nil?
      class << @response
        def body; self.inspect; end
      end
    end
  end
  def get(url)
    return @response if !@response.nil?
    response = Hash.new
    response['rsp'] = Hash.new
    response['rsp']['stat'] = 'ok'
    class << response
      def body
          '<rsp stat=''ok'' />'
      end
    end
    response
  end
end

class REXML::Formatters::Pretty
  # fix cockup in RCov
  def wrap(string, width)
    return string;
    # Recursivly wrap string at width.
    return string if string.length <= width
    place = string.rindex(' ', width) # Position in string with last ' ' before cutoff
    return string if place.nil?
    return string[0,place] + "\n" + wrap(string[place+1..-1], width)
  end
end

class TestBase < Test::Unit::TestCase
  def test_true
  end

  def endpoint(response=nil)
    Endpoint.new('a','b',MockHttp.new(response))
  end

  def get_rtm(use_token=true,response=nil)
    rtm = RTM::RTM.new(endpoint(response))
    rtm.token = 'fake_token' if use_token
    rtm
  end
end

