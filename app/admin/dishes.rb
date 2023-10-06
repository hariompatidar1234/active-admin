ActiveAdmin.register Dish do
  permit_params :name, :price, :category_id, :restaurant_id, :image
  index do
    selectable_column
    id_column
    column :image do |img|
      image_tag url_for(img.image), size: '30x30' if img.image.present?
    end
    column :name
    column :price
    column :category_id
    column :restaurant_id
    actions
  end
  filter :name
  filter :price
  filter :category_id
  filter :restaurant_id
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :price
      f.input :category_id ,label: "Category_id", hint: "Category_id must be integer"
      f.input :restaurant_id ,label: "Restaurant_id" , hint: "Restaurant_id must be integer"
      f.input :image, as: :file
    end
    f.actions
  end
  show do
    attributes_table do
      row :name
      row :price
      row :category_id
      row :restaurant_id
      row :image do |img|
        image_tag url_for(img.image), size: '200x150' if img.image.present?
      end
    end
  end
end
