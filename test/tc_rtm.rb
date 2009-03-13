require 'rtm'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'testbase'
include RTM

class TC_testRTM < TestBase

  def test_weird_error
    http = MockHttp.new({'rsp' => { 'stat' => 'fail'}})
    rtm = RTM::RTM.new('a','b','c')
    rtm.http = http
    assert_raises VerificationException do
      rtm.tasks.getList
    end
  end

  def test_test
    http = MockHttp.new()
    rtm = RTM::RTM.new('a','b','c')
    rtm.http = http
    rtm.test.echo
  end

  def test_bad_method_call
    http = MockHttp.new()
    rtm = RTM::RTM.new('a','b','c')
    rtm.http = http
    assert_raises NoMethodError do
      rtm.tasks(4,5,6)
    end
  end

  def test_tasks_notes
    http = MockHttp.new
    rtm = RTM::RTM.new('a','b','c')
    rtm.http = http
    response = rtm.tasks.notes.add
    assert_equal('ok', response['stat'])
  end

  def test_basic
    http = MockHttp.new
    rtm = RTM::RTM.new('a','b','c')
    rtm.http = http
    response = rtm.tasks.getList
    assert_equal('ok', response['stat'])
  end
end
