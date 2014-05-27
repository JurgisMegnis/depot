class Article < ActiveRecord::Base
  validates :title, :article, presence: true
end
