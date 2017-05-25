class Node < ApplicationRecord
  scope :marathon, -> { where(source: "marathon") }
  scope :redis, -> { where(source: "redis") }
  has_many :apps
end
