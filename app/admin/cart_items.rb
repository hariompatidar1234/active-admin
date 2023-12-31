ActiveAdmin.register CartItem do
  permit_params :dish_id, :quantity, :cart_id

  index do
    selectable_column
    id_column
    column :dish_id
    column :quantity
    column :cart_id
    actions
  end
  filter :dish_id
  filter :quantity
  filter :cart_id
  filter :created_at

  form do |f|
    f.inputs do
      f.input :dish_id, hint: "Dish_id must be integer"
      f.input :quantity
      f.input :cart_id , hint: "Cart_id must be integer"
    end
    f.actions
  end
end
