FactoryBot.define do
  factory :question do
    question { Faker::Friends.quote }
    option_a { Faker::Friends.quote }
    option_b { Faker::Friends.quote }
    option_c { Faker::Friends.quote }
    option_d { Faker::Friends.quote }
    correct_option { %w[A B C D].sample }
  end
end
