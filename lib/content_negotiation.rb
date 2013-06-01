module ContentNegotiation
  protected
  def is_device_request?
    is_ios_request? || is_android_request?
  end

  def is_iphone_request?
    return false if request.nil? || request.user_agent.nil?
    request.user_agent =~ /(iphone|ipod|deals)/i
  end

  def is_ipad_request?
    request.user_agent =~ /ipad/i
  end

  def is_ios_request?
    is_iphone_request? || is_ipad_request?
  end

  def is_android_request?
    (request.user_agent =~ /android/i && request.user_agent =~ /webkit|dalvik/i) || request.user_agent =~ /HTC_Sensation/
  end

  def is_other_mobile_webkit_request?
    return false if request.nil? || request.user_agent.nil?
    #blackberry, but only torch (or newer blackberry devices using webkit)
    return true if request.user_agent.match(/BlackBerry/i) && request.user_agent.match(/AppleWebKit/i)
    #all webOS browsers
    return true if request.user_agent.match(/webOS/i) && request.user_agent.match(/AppleWebKit/i)
    return false
  end
end
