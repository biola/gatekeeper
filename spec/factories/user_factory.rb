FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    user_agent { 'Mozilla/4.0 (compatible; MSIE 5.5; AOL 4.0; Windows 98)' }
    ip_address { Faker::Internet.ip_v4_address }
  end
end
