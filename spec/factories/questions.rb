FactoryBot.define do
  sequence :title do |n|
    "RandomTitleText#{n}"
  end

  factory :question do
    title
    body
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
