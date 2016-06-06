class Download

  def initialize(token, remote_ip)
    @token = Token.find_by(:token_value => token)
    @remote_ip = remote_ip
  end

  def authorized?
    if !@token.nil? && ((Time.now - @token.issued) < 3600) && !@token.download_limit.nil? && (@token.download_limit > @token.download_count)
      return true
    else
      return false
    end
  end

  def checkout_download
    if authorized?
      increment_and_record
      "#{ENV['DOWNLOAD_DIRECTORY']}/#{@token.filename}"
    end
  end

  def increment_and_record
    @token.download_count += 1
    @token.last_download_ip = @remote_ip unless @remote_ip.blank?
    @token.save
  end
  
end

