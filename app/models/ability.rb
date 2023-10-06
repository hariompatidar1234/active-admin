class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, User
    can :login, User
    can :forgot_password, User
    can :reset_password, User
    can :read, [Dish, Category, Restaurant, Order]

    if user.type == 'Owner'
      can :manage, [Restaurant, Category, Dish]
      can :my_restaurants_list, Restaurant
      can :owner_dishes, Dish
    elsif user.type == 'Customer'
      can :manage, Cart
      can :manage, Order
      can :destroy_all, Cart
    end
  end
end
