require 'httparty'

module RTM
  # Acts as the endopint to RTM actions, providing a means to separate the API's behavior
  # with interaction with RTM.
  class Endpoint
    NO_TIMELINE = {
      "rtm.contacts.getList" => true,
      "rtm.groups.getList" => true,
      "rtm.lists.getList" => true,
      "rtm.reflection.getMethodInfo" => true,
      "rtm.reflection.getMethods" => true,
      "rtm.settings.getList" => true,
      "rtm.tasks.getList" => true,
      "rtm.test.echo" => true,
      "rtm.test.login" => true,
      "rtm.time.convert" => true,
      "rtm.time.parse" => true,
      "rtm.timelines.create" => true,
      "rtm.timezones.getList" => true,
      "rtm.transactions.undo" => true,
    }
    BASE_URL = 'https://api.rememberthemilk.com/services/'

    # Create an endpoint to RTM, upon which methods may be called.
    # [api_key] your api key
    # [secret] your secret
    # [http] a class that acts like HTTParty (omit; this is used for testing mostly)
    def initialize(api_key,secret,http=HTTParty)
      @api_key = api_key
      @secret = secret
      @http=http
      raise "Cannot work with a secret key" if @secret.nil?
      raise "Cannot work with a api_key key" if @api_key.nil?
    end

    def auto_timeline=(auto)
      @auto_timeline = auto
    end

    # Update the token used to access this endpoint
    def token=(token)
      @token = token
    end

    def last_timeline
      @last_timeline
    end

    # Calls the RTM method with the given parameters
    # [method] the full RTM method, e.g. rtm.tasks.getList
    # [params] the parameters to pass, can be symbols.  api_key, token, and signature not required
    # [token_required] if false, this method will not require a token
    def call_method(method,params={},token_required=true)
      @last_timeline = nil
      raise NoTokenException if token_required && (!@token || @token.nil?)
      params = {} if params.nil?
      params[:auth_token] = @token if !@token.nil?

      if (@auto_timeline && !NO_TIMELINE[method])
        response = @http.get(url_for('rtm.timelines.create',{'auth_token' => @token}));
        if response['timeline']
          @last_timeline = response['timeline']
          params[:timeline] = @last_timeline
        else
          raise BadResponseException, "Expected a <timeline></timeline> type response, but got: #{response.body}"
        end
      end

      params_no_symbols = Hash.new
      params.each do |k,v|
        params_no_symbols[k.to_s] = v
      end

      response = @http.get(url_for(method,params_no_symbols))
      verify(response)
      return response['rsp']
    end

    # Get the url for a particular call, doing the signing and all that other stuff.
    #
    # [method] the RTM method to call
    # [params] hash of parameters.  The +method+, +api_key+, and +api_sig+ parameters should _not_ be included.
    # [endpoint] the endpoint relate to BASE_URL at which this request should be made.  
    def url_for(method,params={},endpoint='rest')
      params['api_key'] = @api_key
      params['method'] = method if method
      signature = sign(params)
      url = BASE_URL + endpoint + '/' + params_to_url(params.merge({'api_sig' => signature}))
      url
    end


    private

    # quick and dirty way to check the response we got back from RTM.
    # Call this after every call to RTM.  This will verify that you got <rsp> with a "stat='ok'"
    # and, if not, make a best effort at raising the error message from RTM.
    #
    # [response] the response from HTTParty from RTM
    def verify(response)
      raise BadResponseException, "No response at all" if !response || response.nil?
      raise BadResponseException, "Got response with no body" if !response.body
      raise BadResponseException, "Didn't find an rsp element, response body was #{response.body}" if !response["rsp"]
      raise BadResponseException, "Didn't find a stat in the <rsp> element, response body was #{response.body}" if !response["rsp"]["stat"]
      if response['rsp']['stat'] != 'ok'
        err = response['rsp']['err']
        if err
          code = err['code']
          msg = err['msg']
          raise VerificationException, "ERROR: Code: #{code}, Message: #{msg}"
        else
          raise VerificationException, "Didn't find an <err> tag in the response for stat #{response['rsp']['stat']}, response body was #{response.body}" 
        end
      end
    end

    # Turns params into a URL
    def params_to_url(params)
      string = '?'
      params.each do |k,v|
        string += CGI::escape(k)
        string += '='
        string += CGI::escape(v)
        string += '&'
      end
      string
    end

    # Signs the request given the params and secret key
    #
    # [params] hash of parameters
    #
    def sign(params)
      raise "Something's wrong; @secret is nil" if @secret.nil?
      sign_me = @secret
      params.keys.sort.each do |key|
        sign_me += key
        raise "Omit params with nil values; key #{key} was nil" if params[key].nil?
        sign_me += params[key]
      end
      return Digest::MD5.hexdigest(sign_me)
    end

  end
end
