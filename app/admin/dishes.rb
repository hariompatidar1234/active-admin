ActiveAdmin.register Dish do
  permit_params :name, :price, :category_id, :restaurant_id, :picture

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :category_id
    column :restaurant_id
    column :picture
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
      f.input :category_id
      f.input :restaurant_id
      f.file_field :picture
    end
    f.actions
  end
end
