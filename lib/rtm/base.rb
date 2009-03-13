require 'httparty'

module RTM
  # Base for RTM classes
  class RTMBase
    BASE_URL = 'http://www.rememberthemilk.com/services/'

    def http
      return @http
    end

    def http=(new_http)
      @http = new_http
    end

    # Create
    def initialize(api_key,secret,http=nil)
      @api_key = api_key
      @secret = secret
      @http=http
      @http=HTTParty if http.nil?
      raise "Cannot work with a secret key" if @secret.nil?
      raise "Cannot work with a api_key key" if @api_key.nil?
    end

    # Stolen from sequel
    def camelize(string,first_letter_in_uppercase = :lower)
      s = string.gsub(/\/(.?)/){|x| "::#{x[-1..-1].upcase unless x == '/'}"}.gsub(/(^|_)(.)/){|x| x[-1..-1].upcase}
      s[0...1] = s[0...1].downcase unless first_letter_in_uppercase == :upper
      s
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

  class VerificationException < Exception
  end

  class BadResponseException < Exception
  end

  class InvalidTokenException < Exception
  end

  class NoTokenException < Exception
  end
end
