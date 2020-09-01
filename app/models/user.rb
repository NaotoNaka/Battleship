class User < ApplicationRecord
  has_secure_password
  validates :loginname, presence: true
end
