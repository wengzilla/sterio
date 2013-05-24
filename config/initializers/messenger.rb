PUBNUB = Pubnub.new(
    "pub-b0ec0cb4-6582-4e85-9c9e-1eae9873461a",  ## PUBLISH_KEY
    "sub-7c99adeb-fb9b-11e0-8d34-3773e0dc0c14",  ## SUBSCRIBE_KEY
    "sec-e5df88e2-cbf9-4b4a-8ec6-795dc1b15f1e",  ## SECRET_KEY
    "",      ## CIPHER_KEY (Cipher key is Optional)
    false    ## SSL_ON?
)

class Messenger
  def self.send(channel, msg)  
    PUBNUB.publish({
      'channel' => channel,
      'message' => msg,
      'callback' => Proc.new {}
    })
  end  
end