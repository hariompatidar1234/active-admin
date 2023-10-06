ActiveAdmin.register Restaurant do
  permit_params :name, :address, :user_id, :status, :image

  index do
    selectable_column
    id_column
    column :image do |img|
      image_tag url_for(img.image), size: '30x30' if img.image.present?
    end
    column "Restaurant_Name",:name
    column "Location" ,:address
    column "Owner_Id",:user_id
    column "Open/Closed",:status
    actions
  end

  filter :name,label: "Restaurant_name"
  filter :address,label: "Location"
  filter :status
  filter :user_id,label: "User_Id"
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name,label: "Restaurant Name"
      f.input :address,label: "Restaurant Address"
      f.input :status ,label: 'Status(open/closed)'
      f.input :user_id , label: "User_Id", hint: "only Owner    Id"
      f.input :image, as: :file,label: "Restaurant Photo"
    end
    f.actions
  end

  show do
    attributes_table do
      row :name,label: "Restaurant_name"
      row :address
      row :status
      row :user_id
      row :created_at
      row :image do |img|
        image_tag url_for(img.image), size: '200x150' if img.image.present?
      end
    end
  end
  # ActiveAdmin.setup do |config|
  #   config.create_another = true
  # end
end
