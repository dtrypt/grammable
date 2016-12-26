require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#destroy action" do
    it "should allow user to destroy grams" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, id: gram.id
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it "should return 404 error if gram does not exist" do
      delete :destroy, id: "nonexistant"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do
    it "should allow users to successfully update grams" do
      gram = FactoryGirl.create(:gram)
      patch :update, id: gram.id, gram: {message: 'Hello again!'}
      expect(response).to redirect_to gram_path(gram.id)
      gram.reload
      expect(gram.message).to eq("Hello again!")
    end

    it "should have http 404 error if the gram cannot be found" do
      patch :update, id: "nonexistant", gram: {message: 'Hello again!'}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      gram = FactoryGirl.create(:gram)
      patch :update, id: gram.id, gram: { message: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq("hello")
    end
  end

  describe "grams#edit action" do
    it "should successfully show the edit form if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :edit, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      get :edit, id: 'nonexistant'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "gram#show action" do
    it "should successfully show page if gram id exists" do
      gram = FactoryGirl.create(:gram)
      get :show, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return 404 error is gram if not found" do
      get :show, id: 'nonexistant'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#index action" do
    it "should show the page successfully" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should show the new form successfully" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do

    it "should require users to be logged in" do
      post :create, gram: {message: "Hello"}
      expect(response).to redirect_to new_user_session_path
    end

    it "should post the user's gram (creating gram in our database)
    and send to gram's show page" do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, gram: {message: 'Hello!'}
      expect(response).to redirect_to gram_path(Gram.last)

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly show validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram: {message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end

end
