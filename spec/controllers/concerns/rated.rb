require 'rails_helper'

  shared_examples_for "rated" do

  sign_in_user

  describe 'POST like' do
    it 'increases resource likes' do
      expect { post :like, params: { id: resource } }.to change(resource.rates, :count).by(1)
    end

    it 'resets like action' do
      post :like, params: { id: resource }
      expect { post :like, params: { id: resource } }.to change(resource.rates, :count).by(-1)
    end

    it 'doesn\'t increase resource likes if author tries to like it' do
      expect { post :like, params: { id: author_resource } }.to_not change(author_resource.rates, :count)
    end
  end

  describe 'POST dislike' do
    it 'increases resource dislikes' do
      expect { post :like, params: { id: resource } }.to change(resource.rates, :count).by(1)
    end

    it 'resets dislike action' do
      post :dislike, params: { id: resource }
      expect { post :dislike, params: { id: resource } }.to change(resource.rates, :count).by(-1)
    end

    it 'doesn\'t increase resource dislikes if author tries to dislike it' do
      expect { post :dislike, params: { id: author_resource } }.to_not change(author_resource.rates, :count)
    end
  end
end
