class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :status, :user_id, :picture_url
  has_many :dishes

  def picture_url
    Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attached?
  end
end
