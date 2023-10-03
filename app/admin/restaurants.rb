ActiveAdmin.register Restaurant do

   permit_params :name, :address, :user_id, :status,:image

  index do
    selectable_column
    id_column
    column :image do |img|
      image_tag url_for(img.image), size: "30x30" if img.image.present?
    end
    column :name
    column :address
    column :user_id
    column :status
    actions
  end

  filter :name
  filter :address
  filter :status
  filter :user_id
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :address
      f.input :status
      f.input :user_id
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :address
      row :status
      row :user_id
      row :created_at
      row :image do |img|
        image_tag url_for(img.image), size: "200x150" if img.image.present?
      end
    end
  end
end
