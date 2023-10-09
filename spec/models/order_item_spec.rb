require 'rails_helper'

RSpec.describe OrderItem, type: :model do
    describe "association" do
    it { should belong_to(:dish)}
    it { should belong_to(:cart)}
  ends
end
