class TokenController < ApplicationController
  def generate
    if user_signed_in? && (current_user == User.find('575452d2d3fbafeb03000000'))
      token = Token.new(:token_value => SecureRandom.base64(25).tr('+/=lIO03', 'abc123'), :issued => Time.now, :filename => params[:file], :download_count => 0, :download_limit => (params[:limit].to_i || 1))
      if token.save
        render text: "A download token has been created for you<br><br>Number of possible downloads: #{token.download_limit}<br>Filename: #{token.filename}<br>Token: <b>#{token.token_value}</b><br>It will be valid for one hour from #{token.issued}"
      end
    end
  end
end
