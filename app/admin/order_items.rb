ActiveAdmin.register OrderItem do
  permit_params :dish_id,:quantity ,:order_id

  index do
    selectable_column
    id_column
    column :dish_id
    column :quantity
    column :order_id
    actions
  end
  filter :dish_id
  filter :quantity
  filter :order_id
  filter :total_amount
  filter :created_at

  form do |f|
    f.inputs do
      f.input :dish_id
      f.input :quantity
      f.input :order_id
    end
    f.actions
  end
end
