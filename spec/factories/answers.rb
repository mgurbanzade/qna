FactoryBot.define do
  sequence :body do |n|
    "RandomBodyText#{n}"
  end

  factory :answer do
    body
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
