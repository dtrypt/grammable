FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end

  factory :gram do
    #picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png'), 'image/png')}
    #picture "hello"
    message "hello"
    association :user
  end
  
end