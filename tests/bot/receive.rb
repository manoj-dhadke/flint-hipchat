from_mention_name  = @input.path("$.item.message.from.mention_name")
message = @input.path("$.item.message.message")
message_type = @input.path("$.item.message.type")
room_name = @input.path("$.item.room.name")

@log.info("message::"+@input.to_s)
message_to_send = "Hello @#{from_mention_name}! You requested #{message}"

# Call flintbit synchronously and set arguments
flintbit_response = @call.bit("flint-hipchat:bot:send.rb")         # Provide path for flintbit
                      .set("message",message_to_send) # Set arguments\
                      .set("room",room_name)
                      .sync                               # To call flintbit asynchronously use .async instead of .sync
