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
end
