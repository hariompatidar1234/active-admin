ActiveAdmin.register Restaurant do

   permit_params :name, :address, :user_id, :status,:picture

  index do
    selectable_column
    id_column
    column :name
    column :address
    column :user_id
    column :status
    column :picture
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
      f.input :picture, as: :file
    end
    f.actions
  end

end
