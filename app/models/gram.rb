class Gram < ActiveRecord::Base
  #validates :picture, presence: true
  validates :message, presence: true
  belongs_to :user
  has_many :comments
  mount_uploader :picture, PictureUploader
end
