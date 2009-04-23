require 'moocow'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'testbase'
require 'string_camelize'
include RTM

class TC_testAuth < TestBase
  
  def test_get_set_frob
    rtm = get_rtm
    auth = rtm.auth

    frob = 'this is a frob'
    auth.frob = frob
    assert_equal frob,auth.frob
  end

  def test_bad_check_token_call
    rtm = get_rtm
    assert_raises RuntimeError do
      rtm.auth.check_token
    end
  end

  def test_check_token_good
    rtm = get_rtm
    rtm.check_token
  end

  def test_check_token_bad
    rtm = get_rtm(true,{'rsp' => 
                  { 'stat' => 'fail', 'err' => 
                    { 'code' => '98', 'msg' => 'Invalid auth token' }
                  }
    });
    assert_raises InvalidTokenException do
      rtm.check_token
    end
  end

  def test_update_token
    http = MockHttp.new
    class << http
      def get(url)
        response = Hash.new
        response['rsp'] = Hash.new
        response['rsp']['stat'] = 'ok'
        if url =~ /rtm.auth.getFrob/
          response['rsp']['frob'] = 'this_is_a_fake_frob'
          class << response
            def body
          '<rsp stat=''ok''><frob>this_is_a_fake_frob</frob></rsp>'
            end
          end
          return response
        elsif url =~ /rtm.auth.getToken/
          response['rsp']['auth'] = Hash.new
          response['rsp']['auth']['token'] = 'this_is_a_fake_token'
          class << response
            def body
          '<rsp stat=''ok''><auth><token>this_is_a_fake_token</token></auth></rsp>'
            end
          end
          return response
        else
          return super(url)
        end
      end
    end
    endpoint = Endpoint.new('a','b',http)
    rtm = RTM::RTM.new(endpoint)
    assert_raises NoTokenException do
      rtm.tasks.getList
    end

    # Now, we simulate getting the token
    auth = rtm.auth
    url = auth.url
    # user would get sent to this url and click OK, validating the frob
    token = auth.get_token
    rtm.token = token
    response = rtm.tasks.getList
    assert_equal('ok', response['stat'])
  end

end
