require 'string_rtmize'
module RTM

  # Implements authorization related tasks.  These are to be used one-time only
  # when the user first uses your application.
  #
  #     auth = RTMAuth.new(api_key,secret)
  #     url = auth.get_auth_url
  #     # send user to url
  #     # When they have done so
  #     token = auth.get_token
  #     # object auth no longer needed; use token with RTM
  class RTMAuth
    def initialize(endpoint)
      @endpoint = endpoint
    end

    # Get the URL to allow the user to authorize the application
    # [perms] the permissions you wish to get, either :read, :write, or :delete
    # [application_type] if :desktop, a frob is gotten and the URL is suitable for a desktop application.  if :web, a url suitable for the web is returned.
    # [callback_url] the callback URL you want the user sent to after they authorize.  This will have the frob and you must call frob= before get_token with the frob that was given to you.
    def url(perms = :delete, application_type=:desktop, callback_url=nil)
      @frob = get_frob if application_type == :desktop
      params = {'perms' => perms.to_s}
      params['frob'] = @frob if @frob
      params['callbackURL'] = callback_url if callback_url
      @endpoint.url_for(nil,params,'auth')
    end

    # After the user has authorized, gets the token
    def get_token
      response = @endpoint.call_method('rtm.auth.getToken', { 'frob' => @frob }, false)
      response['auth']['token']
    end
    alias :getToken :get_token

    def check_token
      raise "checkToken should be called on the RTM object directly";
    end
    alias :checkToken :check_token

    def get_frob
      response = @endpoint.call_method('rtm.auth.getFrob',nil,false)
      @frob = response['frob']
      @frob
    end
    alias :getFrob :get_frob

    # After a call to get_frob, this returns the frob that was gotten.
    def frob
      @frob
    end

    def frob=(frob)
      @frob=frob
    end
  end
end

