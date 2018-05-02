FactoryBot.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/logo.png") }
  end
end
