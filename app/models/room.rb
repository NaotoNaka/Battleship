class Room < ApplicationRecord
  validates :loginname, presence: true
end
