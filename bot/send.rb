require 'json'

message = @input.get("message")
room_name = @input.get("room")
color = @input.get("color")
notify = @input.get("notify")


if color == nil
  @log.debug("Setting color to green from Global Config ")
  color = "green"
end

if notify == nil
  @log.debug("Setting notify to true from Global Config ")
  notify = true
end


http_connector = @config.global("flint-hipchat-bots.http_connector")

send_url = @config.global("flint-hipchat-bots.#{room_name}.send_url")

# Valuidate Authrization values
if http_connector.nil? && send_url.nil?
   @output.exit(1,"you must configure http_connector,send_url in global configuration")
end

# validate sms message parameters
if room_name.nil? && message.nil?
   @output.exit(2,"you must provide room,message in request")
end

http_body = { "color" => color, "message" => message, "notify" => notify, "message_format" => "text" }

@log.trace("Calling Hipchat API...")
hipchat_response = @call.connector(http_connector)
                    .set("method","post")   #HTTP request method
                    .set("url",send_url)
                    .set("body",http_body.to_json)
                    .set("headers",["Cache-Control:no-cache","Content-Type: application/json"])  #HTTP request headers
                    .set("timeout",10000) #Execution time of the Flintbit in milliseconds
                    .sync

#HTTP Connector Response Meta Parameters
response_exitcode = hipchat_response.exitcode   #Exit status code
response_message = hipchat_response.message     #Execution status message

#HTTP Connector Response Parameters
response_body = hipchat_response.get("body")       #Response Body
response_headers = hipchat_response.get("headers") #Response Headers

if response_exitcode == 0
    @log.info('Success in executing HTTP Connector where, exitcode ::'+response_exitcode.to_s+' | message :: '+response_message)
    @output.setraw("result",@util.json(response_body).to_s)
else
    @log.error('Failure in executing HTTP Connector where, exitcode ::'+response_exitcode.to_s+' | message :: ' +response_message)
    @output.set("error",response_message)
end
