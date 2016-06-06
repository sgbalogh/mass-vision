class Token
  include Mongoid::Document
  field :token_value, type: String
  field :issued, type: Time
  field :filename, type: String
  field :download_count, type: Integer
  field :download_limit, type: Integer
  field :last_download_ip, type: String

end
