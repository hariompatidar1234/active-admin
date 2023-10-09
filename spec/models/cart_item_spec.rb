require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe "association" do
    it { should belong_to(:dish)}
    it { should belong_to(:cart)}
  end
end
