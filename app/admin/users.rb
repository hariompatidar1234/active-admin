ActiveAdmin.register User do
  # actions :all, except: [:update, :destroy,:edit]
  permit_params :name, :email, :type, :image, :password

  index do
    selectable_column
    id_column
    column :image do |img|
      image_tag url_for(img.image), size: '30x30' if img.image.present?
    end
    column "User Name",:name
    column :email
    column :type
    actions
  end
  filter :name
  filter :email
  filter :type

  form do |f|
    f.inputs do
      f.input :name,label: "User Name"
      f.input :email ,lable: "Email" , hint: "Email like [yourname@gmail.com]"
      f.input :type, label: 'Type(Customer/Owner)'
      f.input :password,label: "password"
      f.input :image, as: :file ,label: "User Profile"
      f.semantic_errors *f.object.errors.keys
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :type
      row :image do |img|
        image_tag url_for(img.image), size: '200x150' if img.image.present?
      end
    end
  end
end
