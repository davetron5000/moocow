require 'rtm'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'testbase'
include RTM

class TC_testRTM < TestBase

  def test_weird_error
    rtm = get_rtm(true,{'rsp' => { 'stat' => 'fail'}})
    assert_raises VerificationException do
      rtm.tasks.getList
    end
  end

  def test_test
    rtm = get_rtm
    rtm.test.echo
  end

  def test_bad_method_call
    rtm = get_rtm
    assert_raises NoMethodError do
      rtm.tasks(4,5,6)
    end
  end

  def test_tasks_notes
    rtm = get_rtm
    response = rtm.tasks.notes.add
    assert_equal('ok', response['stat'])
  end

  def test_basic
    rtm = get_rtm
    response = rtm.tasks.getList
    assert_equal('ok', response['stat'])
  end

  FAKE_TIMELINE = '123456789'

  def get_timeline_http()
    http = MockHttp.new
    class << http
      def get(url)
        if url =~/method=rtm.timelines.create/
          response = {'timeline' => FAKE_TIMELINE}
          class << response
            def body
              "<timeline>#{FAKE_TIMELINE}</timeline>"
            end
          end
          return response
        else
          if url =~ /timeline=(\d+)/
            if $1 != FAKE_TIMELINE
              raise "Expected #{FAKE_TIMELINE} but got #{$1}"
            end
          else
            raise "Expected timeline to be in request url '#{url}'"
          end
          return super(url)
        end
      end
    end
    http
  end

  def get_bad_timeline_http()
    http = MockHttp.new
    class << http
      def get(url)
          response = {'rsp' => {'stat' => 'err'} }
          class << response
            def body
              "<rsp stat='err'>Blah</rsp>"
            end
          end
          response
      end
    end
    http
  end

  def test_auto_timeline
    ep = Endpoint.new('a','b',get_timeline_http())
    ep.auto_timeline = true
    rtm = RTM::RTM.new(ep)
    ep.token = 'blah'
    rtm.tasks.add(:name => 'foo')
  end

  def test_auto_timeline_error
    ep = Endpoint.new('a','b',get_bad_timeline_http())
    ep.auto_timeline = true
    rtm = RTM::RTM.new(ep)
    ep.token = 'blah'
    assert_raises BadResponseException do
      rtm.tasks.add(:name => 'foo')
    end
  end
end
