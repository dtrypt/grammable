require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    it "should require users to be logged in to comment" do
      gram = FactoryGirl.create(:gram)
      post :create, gram_id: gram.id, comment: {remark: "Nice pic"}
      expect(response).to redirect_to new_user_session_path
    end

    it "should return Error if gram does not exist" do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, gram_id: "not available", comment: {remark: "Nice pic"}
      expect(response).to have_http_status(:not_found)
    end

    it "should allow users to post comments on grams" do
      user = FactoryGirl.create(:user)
      sign_in user
      gram = FactoryGirl.create(:gram)
      post :create, gram_id: gram.id, comment: {remark: "Nice pic"}
      expect(response).to redirect_to root_path
      comment = Comment.last
      expect(comment.remark).to eq("Nice pic")
    end
  end
end
