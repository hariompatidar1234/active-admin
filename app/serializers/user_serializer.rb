class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :type, :picture_url, :created_at
  def picture_url
    Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attached?
  end
end
