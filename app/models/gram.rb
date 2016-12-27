class Gram < ActiveRecord::Base
  #validates :picture, presence: true
  validates :message, presence: true
  belongs_to :user
  mount_uploader :picture, PictureUploader
end
