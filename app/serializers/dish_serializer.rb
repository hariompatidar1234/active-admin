class DishSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :picture_url

  belongs_to :restaurant
  belongs_to :category

  def picture_url
    Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attached?
  end
end
