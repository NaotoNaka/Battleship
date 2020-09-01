class Lobby < ApplicationRecord
  validates :loginname, presence: true
end