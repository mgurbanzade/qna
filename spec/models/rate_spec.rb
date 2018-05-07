require 'rails_helper'

RSpec.describe Rate, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:rateable) }
  it { should validate_presence_of :vote }
  it { should validate_uniqueness_of(:user_id).scoped_to(:rateable_id, :rateable_type) }
  it { should allow_value(1, -1).for(:vote) }
end
