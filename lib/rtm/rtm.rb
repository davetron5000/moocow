require 'rubygems'
require 'digest/md5'
require 'cgi'
require 'rtm/base'

module RTM
  # Root access to RTM api.
  # Most methods work just like the api demonstrates, however auth is a bit different:
  #
  #     rtm = RTM.new(api_key,secret)
  #     auth_url = rtm.auth.url
  #     # Send user to url
  #     # When they click authorize and return to your app do:
  #     rtm.token=rtm.auth.get_token
  #
  # This is a one time thing, so cache the token somewhere and you are good to go:
  #
  #     response = rtm.tasks.getList(:filter => 'location:Work and status:completed')
  #     response = rtm.groups.add(:group => 'My New Group')
  #
  # If you don't supply timelines, they will be created for you each time as needed.
  # Also note that you can use Ruby-style method calls instead of filthy camel-case, e.g.
  #
  #     response = rtm.tasks.get_list(:filter => 'location:Work and status:completed')
  #     # Same as 
  #     response = rtm.tasks.getList(:filter => 'location:Work and status:completed')
  #
  class RTM < RTMBase

    # Create access to RTM
    # 
    # [api_key] your api key
    # [secret]  your shared secret
    # [token] the token your user has acquired after authorizing (via RTMAuth)
    # [http] HTTP implementation; mostly useful for testing
    def initialize(api_key,secret,token=nil,http=nil)
      super(api_key,secret,http)
      @token = token
    end

    # Set the token
    def token=(token)
      @token = token
    end

    # Get the auth method-space
    def auth
      RTMAuth.new(@api_key,@secret,http)
    end

    # Raises an InvalidTokenException if the token is not valid
    def check_token
      response = http.get(url_for('rtm.auth.checkToken',{'auth_token' => @token}))
      begin
        verify response
      rescue VerificationException
        raise InvalidTokenException
      end
    end
    alias :checkToken :check_token



    # Get the test method-space (Kernel defines a test method, making method_missing problematic)
    def test
      return RTMMethod.new('test',@api_key,@secret,@token,http)
    end

    # Gateway to all other method-spaces.  Assumes you are making a valid call
    # on RTM.  Essentially, *any* method will give you an RTMMethod object keyed to the
    # method name, e.g. rtm.foobar will assume that RTM has a "foobar" methodspace.
    # method names are converted to camelcase.
    def method_missing(symbol,*args)
      if !args || args.empty?
        rtm_object = camelize(symbol.to_s)
        return RTMMethod.new(rtm_object,@api_key,@secret,@token,http)
      else
        return super(symbol,*args)
      end
    end

  end

  # Generic means of calling an RTM method.  This is returned by RTM.method_missing and, in most cases, is
  # the end point that calls an RTM method.  
  class RTMMethod < RTMBase
    # Creates an RTMMethod for the given name, api_key, secret, and token
    def initialize(name,api_key,secret,token,http=nil)
      super(api_key,secret,http)
      @token = token
      @name = name
    end

    # Calls the method on RTM in most cases.  The only exception is if this RTMMethod is 'tasks' and you
    # call the 'notes' method on it: a new RTMMethod is returned for the 'rtm.tasks.notes' method-space.
    #
    # This returns a response object as from HTTParty, dereferenced into <rsp>.  So, for example, if you called
    # the 'tasks.getList' method, you would get a hash that could be accessed via response['tasks'].
    # This object is a Hash and Array structure that mimcs the XML returned by RTM.  One quirk is that for methods that could return 1 or more
    # of the same item (tasks.getList is a good example; it will return multilple <list> elements unless you restrict by list, in which case
    # it returns only one <list> element).   Because HTTParty doesn't understand this, you may find it convienient to convert such
    # results to arrays.  the to_array extension on Hash and Array accomplish this:
    #
    #     response = rtm.tasks.getList(:filter => 'list:Work')
    #     response['tasks']['list'].as_array.eadch do |list|
    #       list['taskseries'].as_array.each do |task|
    #         puts task['name']
    #       end
    #     end
    #
    # So, call to_array on anything you expect to be a list.
    #
    # This method raises either a BadResponseException if you got a bad or garbled response from RTM or a VerificationException
    # if you got a non-OK response.
    def method_missing(symbol,*args)
      if (@name == 'tasks' && symbol.to_s == 'notes')
        return RTMMethod.new("tasks.notes",@api_key,@secret,@token,@http)
      else
        rtm_method = "rtm.#{@name}.#{camelize(symbol.to_s)}"
        url = nil
        raise NoTokenException if !@token || @token.nil?
        params = { :auth_token => @token }
        params = params.merge(args[0]) if !args.empty?
        params_no_symbols = Hash.new
        params.each do |k,v|
          params_no_symbols[k.to_s] = v
        end
        
        response = http.get(url_for(rtm_method,params_no_symbols))
        verify(response)
        return response['rsp']
      end
    end
  end
end
