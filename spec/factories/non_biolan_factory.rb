FactoryGirl.define do
  factory :non_biolan, class: NonBiolan, parent: User do
    password { Faker::Internet.password }
    referring_url { Faker::Internet.url }

    trait :confirmed do
      confirmed_at { Time.now }
    end
  end
end
