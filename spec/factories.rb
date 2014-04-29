FactoryGirl.define do
  factory :user do
    name      "Fred Monkeybutt"
    email     "fred@monkeybutt.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end