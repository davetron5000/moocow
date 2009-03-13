
# These give Hash and Array a common method that returns an array.
# HTTParty doesn't know if a particular XML element is expected to be
# a list, so when it gets one of that element, it returns it as a Hash.
# So, one can simply call as_array on any part of the XML navigation
# that is expected to be an array, as such:
#
#     response['rsp']['tasks']['list'].as_array.each {|a| }
#
# 

class Hash
  def as_array; [self]; end

  def method_missing(symbol)
    return self[symbol.to_s]
  end
end

class Array
  def as_array; self; end
end
