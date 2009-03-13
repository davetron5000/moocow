require 'rtm'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'testbase'
include RTM

class TC_testAuth < TestBase

  def test_bad_check_token_call
    rtm = RTM::RTM.new('a','b','good token')
    rtm.http = MockHttp.new
    assert_raises RuntimeError do
      rtm.auth.check_token
    end
  end

  def test_check_token_good
    rtm = RTM::RTM.new('a','b','good token')
    rtm.http = MockHttp.new
    rtm.check_token
  end

  def test_check_token_bad
    rtm = RTM::RTM.new('a','b','good token')
    rtm.http = MockHttp.new( {'rsp' => 
                              { 'stat' => 'fail', 'err' => 
                                { 'code' => '98', 'msg' => 'Invalid auth token' }
                              }
    }
);
    assert_raises InvalidTokenException do
      rtm.check_token
    end
  end

  def test_update_token
    http = MockHttp.new
    rtm = RTM::RTM.new('a','b')
    rtm.http = http
    assert_raises NoTokenException do
      rtm.tasks.getList
    end

    # Now, we simulate getting the token
    auth = rtm.auth
    auth.http = MockHttp.new
    class << auth.http
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
    url = auth.url
    # user would get sent to this url and click OK, validating the frob
    token = auth.get_token
    rtm.token = token
    response = rtm.tasks.getList
    assert_equal('ok', response['stat'])
  end

end
