require 'rtm/base'

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
  class RTMAuth < RTMBase
    def initialize(api_key,secret,http=nil)
      super(api_key,secret,http)
    end

    # Get the URL to allow the user to authorize the application
    def url
      @frob = get_frob
      url_for(nil,{'frob' => @frob, 'perms' => 'delete'},'auth')
    end

    # After the user has authorized, gets the token
    def get_token
      response = http.get(url_for('rtm.auth.getToken', { 'frob' => @frob }))
      verify(response)
      response['rsp']['auth']['token']
    end
    alias :getToken :get_token

    def check_token
      raise "checkToken should be called on the RTM object directly";
    end
    alias :checkToken :check_token

    def get_frob
      response = http.get(url_for('rtm.auth.getFrob'))
      verify(response)
      response['rsp']['frob']
    end
    alias :getFrob :get_frob
  end
end
