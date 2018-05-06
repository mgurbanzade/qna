shared_examples_for "rateable" do
  it { should have_many(:rates).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:resource) { create(:question, user: user) }

  describe 'toggle_like method' do
    it 'toggles resource likes' do
      resource.toggle_like(user)
      expect(resource.rating).to eq 1
    end

    it 'adds vote to rates' do
      expect { resource.toggle_like(user) }.to change(resource.rates, :count).by(1)
    end

    it 'removes vote from rates' do
      resource.toggle_like(user)
      expect { resource.toggle_like(user) }.to change(resource.rates, :count).by(-1)
    end
  end

  describe 'toggle_dislike method' do
    it 'toggles resource dislikes' do
      resource.toggle_dislike(user)
      expect(resource.rating).to eq -1
    end

    it 'adds vote to rates' do
      expect { resource.toggle_dislike(user) }.to change(resource.rates, :count).by(1)
    end

    it 'removes vote from rates' do
      resource.toggle_dislike(user)
      expect { resource.toggle_dislike(user) }.to change(resource.rates, :count).by(-1)
    end
  end

  describe 'unvote method' do
    it 'removes all votes of user from rates' do
      resource.toggle_like(user)
      resource.toggle_like(user2)
      expect { resource.unvote(user) }.to change(resource.rates, :count).by(-1)
    end

    it 'doesn\'t remove votes of other users' do
      resource.toggle_like(user)
      resource.toggle_like(user2)
      resource.unvote(user)
      expect(resource.rates.count).to eq 1
    end
  end

  describe 'rating method' do
    it 'returns the sum of votes in rates' do
      resource.toggle_like(user)
      resource.toggle_dislike(user2)
      expect(resource.rating).to eq 0
    end
  end

  describe 'voted? method' do
    it 'checks if user voted' do
      resource.toggle_like(user)
      expect(resource).to be_voted(user)
    end

    it 'checks if user hasn\'t voted yet' do
      expect(resource).to_not be_voted(user)
    end
  end

  describe 'liked? method' do
    it 'checks if user liked the resource' do
      resource.toggle_like(user)
      expect(resource).to be_liked(user)
    end

    it 'checks if user hasn\'t liked the resource yet' do
      expect(resource).to_not be_liked(user)
    end
  end

  describe 'disliked? method' do
    it 'checks if user disliked the resource' do
      resource.toggle_dislike(user)
      expect(resource).to be_disliked(user)
    end

    it 'checks if user hasn\'t disliked the resource yet' do
      expect(resource).to_not be_disliked(user)
    end
  end

  describe 'vote_type method' do
    it 'returns liked if user has liked the resource' do
      resource.toggle_like(user)
      expect(resource.vote_type(user)).to eq 'liked'
    end

    it 'returns disliked if user has disliked the resource' do
      resource.toggle_dislike(user)
      expect(resource.vote_type(user)).to eq 'disliked'
    end

    it 'returns not voted if user hasn\'t voted yet' do
      expect(resource.vote_type(user)).to eq 'not voted'
    end
  end
end
