=begin
##########################################################################
#
#  INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
#  __________________
# 
#  (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
#  All Rights Reserved.
#  Product / Project: Flint IT Automation Platform
#  NOTICE:  All information contained herein is, and remains
#  the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
#  The intellectual and technical concepts contained
#  herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
#  Dissemination of this information or any form of reproduction of this material
#  is strictly forbidden unless prior written permission is obtained
#  from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
=end

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
