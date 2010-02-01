var search_data = {"index":{"info":[["Array","ext/hash_array.rb","classes/Array.html"," < Object","",1],["Hash","ext/hash_array.rb","classes/Hash.html"," < Object","These give Hash and Array a common method that returns an array. HTTParty doesn't know if a particular",1],["RTM","lib/moocow/auth.rb","classes/RTM.html"," < ","",1],["BadResponseException","RTM","classes/RTM/BadResponseException.html"," < Exception","",1],["Endpoint","RTM","classes/RTM/Endpoint.html"," < Object","Acts as the endopint to RTM actions, providing a means to separate the API's behavior with interaction",1],["InvalidTokenException","RTM","classes/RTM/InvalidTokenException.html"," < Exception","",1],["NoTokenException","RTM","classes/RTM/NoTokenException.html"," < Exception","",1],["RTM","RTM","classes/RTM/RTM.html"," < Object","Root access to RTM api. Most methods work just like the api demonstrates, however auth is a bit different:",1],["RTMAuth","RTM","classes/RTM/RTMAuth.html"," < Object","Implements authorization related tasks.  These are to be used one-time only when the user first uses",1],["RTMMethodSpace","RTM","classes/RTM/RTMMethodSpace.html"," < Object","Generic means of calling an RTM method.  This is returned by RTM.method_missing and, in most cases, is",1],["VerificationException","RTM","classes/RTM/VerificationException.html"," < Exception","",1],["String","ext/string_rtmize.rb","classes/String.html"," < Object","",1],["as_array","Array","classes/Array.html#M000032","()","",2],["as_array","Hash","classes/Hash.html#M000030","()","",2],["auth","RTM::RTM","classes/RTM/RTM.html#M000021","()","Get the auth method-space ",2],["auto_timeline=","RTM::Endpoint","classes/RTM/Endpoint.html#M000011","(auto)","",2],["auto_timeline=","RTM::RTM","classes/RTM/RTM.html#M000019","(a)","",2],["call_method","RTM::Endpoint","classes/RTM/Endpoint.html#M000014","(method,params={},token_required=true)","Calls the RTM method with the given parameters [method] the full RTM method, e.g. rtm.tasks.getList [params]",2],["checkToken","RTM::RTM","classes/RTM/RTM.html#M000024","()","Alias for #check_token",2],["checkToken","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000005","()","Alias for #check_token",2],["check_token","RTM::RTM","classes/RTM/RTM.html#M000022","()","Raises an InvalidTokenException if the token is not valid ",2],["check_token","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000004","()","",2],["frob","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000008","()","After a call to get_frob, this returns the frob that was gotten. ",2],["frob=","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000009","(frob)","",2],["getFrob","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000007","()","Alias for #get_frob",2],["getToken","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000003","()","Alias for #get_token",2],["get_frob","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000006","()","",2],["get_token","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000002","()","After the user has authorized, gets the token ",2],["last_timeline","RTM::Endpoint","classes/RTM/Endpoint.html#M000013","()","",2],["last_timeline","RTM::RTM","classes/RTM/RTM.html#M000020","()","Gets the last timeline that was used if in auto-timeline mode ",2],["method_missing","Hash","classes/Hash.html#M000031","(symbol)","",2],["method_missing","RTM::RTM","classes/RTM/RTM.html#M000026","(symbol,*args)","Gateway to all other method-spaces.  Assumes you are making a valid call on RTM.  Essentially, *any*",2],["method_missing","RTM::RTMMethodSpace","classes/RTM/RTMMethodSpace.html#M000029","(symbol,*args)","Calls the method on RTM in most cases.  The only exception is if this RTMMethodSpace is 'tasks' and you",2],["new","RTM::Endpoint","classes/RTM/Endpoint.html#M000010","(api_key,secret,http=HTTParty)","Create an endpoint to RTM, upon which methods may be called. [api_key] your api key [secret] your secret",2],["new","RTM::RTM","classes/RTM/RTM.html#M000017","(endpoint)","Create access to RTM [endpoint] an Endpoint to RTM ",2],["new","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000000","(endpoint)","",2],["new","RTM::RTMMethodSpace","classes/RTM/RTMMethodSpace.html#M000028","(name,endpoint)","Create an RTMMethodSpace [name] the name of this method space, e.g. 'tasks' [endpoint] an endpoing to",2],["rtmize","String","classes/String.html#M000033","(first_letter_in_uppercase = :lower)","Stolen from sequel; gives String a camelize method ",2],["test","RTM::RTM","classes/RTM/RTM.html#M000025","()","Get the test method-space (Kernel defines a test method, making method_missing problematic) ",2],["token=","RTM::Endpoint","classes/RTM/Endpoint.html#M000012","(token)","Update the token used to access this endpoint ",2],["token=","RTM::RTM","classes/RTM/RTM.html#M000018","(token)","Set the token ",2],["url","RTM::RTMAuth","classes/RTM/RTMAuth.html#M000001","(perms = :delete, application_type=:desktop, callback_url=nil)","Get the URL to allow the user to authorize the application [perms] the permissions you wish to get, either",2],["url_for","RTM::Endpoint","classes/RTM/Endpoint.html#M000015","(method,params={},endpoint='rest')","Get the url for a particular call, doing the signing and all that other stuff. [method] the RTM method",2],["README.rdoc","files/README_rdoc.html","files/README_rdoc.html","","= Ruby Client for Remember The Milk  Author::   Dave Copeland (mailto:davetron5000 at g mail dot com)",3],["rtm","files/bin/rtm.html","files/bin/rtm.html","","",3],["hash_array.rb","files/ext/hash_array_rb.html","files/ext/hash_array_rb.html","","These give Hash and Array a common method that returns an array. HTTParty doesn't know if a particular",3],["string_rtmize.rb","files/ext/string_rtmize_rb.html","files/ext/string_rtmize_rb.html","","",3],["moocow.rb","files/lib/moocow_rb.html","files/lib/moocow_rb.html","","",3],["auth.rb","files/lib/moocow/auth_rb.html","files/lib/moocow/auth_rb.html","","",3],["endpoint.rb","files/lib/moocow/endpoint_rb.html","files/lib/moocow/endpoint_rb.html","","",3],["moocow.rb","files/lib/moocow/moocow_rb.html","files/lib/moocow/moocow_rb.html","","",3]],"searchIndex":["array","hash","rtm","badresponseexception","endpoint","invalidtokenexception","notokenexception","rtm","rtmauth","rtmmethodspace","verificationexception","string","as_array()","as_array()","auth()","auto_timeline=()","auto_timeline=()","call_method()","checktoken()","checktoken()","check_token()","check_token()","frob()","frob=()","getfrob()","gettoken()","get_frob()","get_token()","last_timeline()","last_timeline()","method_missing()","method_missing()","method_missing()","new()","new()","new()","new()","rtmize()","test()","token=()","token=()","url()","url_for()","readme.rdoc","rtm","hash_array.rb","string_rtmize.rb","moocow.rb","auth.rb","endpoint.rb","moocow.rb"],"longSearchIndex":["ext/hash_array.rb","ext/hash_array.rb","lib/moocow/moocow.rb","rtm","rtm","rtm","rtm","rtm","rtm","rtm","rtm","ext/string_rtmize.rb","array","hash","rtm::rtm","rtm::endpoint","rtm::rtm","rtm::endpoint","rtm::rtm","rtm::rtmauth","rtm::rtm","rtm::rtmauth","rtm::rtmauth","rtm::rtmauth","rtm::rtmauth","rtm::rtmauth","rtm::rtmauth","rtm::rtmauth","rtm::endpoint","rtm::rtm","hash","rtm::rtm","rtm::rtmmethodspace","rtm::endpoint","rtm::rtm","rtm::rtmauth","rtm::rtmmethodspace","string","rtm::rtm","rtm::endpoint","rtm::rtm","rtm::rtmauth","rtm::endpoint","files/readme_rdoc.html","files/bin/rtm.html","files/ext/hash_array_rb.html","files/ext/string_rtmize_rb.html","files/lib/moocow_rb.html","files/lib/moocow/auth_rb.html","files/lib/moocow/endpoint_rb.html","files/lib/moocow/moocow_rb.html"]}}