ActiveAdmin.register Cart do
  permit_params :user_id

  index do
    selectable_column
    id_column
    column :user_id
    actions
  end
  filter :user_id
  filter :created_at

  form do |f|
    f.inputs do
      f.input :user_id,hint: "User_id must be integer"
    end
    f.actions
  end
end
