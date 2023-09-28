ActiveAdmin.register User do

  permit_params :name, :email, :password, :type

   index do
    selectable_column
    id_column
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
      f.input :password
      f.input :type
    end
    f.actions
  end

end
