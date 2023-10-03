ActiveAdmin.register User do

  permit_params :name, :email,:type, :image

   index do
    selectable_column
    id_column
    column :image do |img|
      image_tag url_for(img.image), size: "30x30" if img.image.present?
    end
    column :name
    column :email
    column :type
    actions
  end
  filter :name
  filter :email
  filter :type
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :type
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :type
      row :image do |img|
        image_tag url_for(img.image), size: "200x150" if img.image.present?
      end
    end
  end

end
