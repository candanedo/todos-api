require 'rails_helper'

describe UsersController do
  let(:user) { User.create(email: 'eduardo.candanedo.94@gmail.com', password: 'secretsecret') }

  before do
    user.reload
  end

  describe '#show' do
    subject do
      get :show, params: {
        id: user.id
      }
    end

    it 'should be a json' do
      expect(subject.status).to eq 200
      expect(subject.header['Content-Type']).to include 'application/json'
    end

    it 'should return all the task that belong to the current user' do
      expect(subject.body).to eq(user.to_json)
    end
  end

  describe '#create' do
    subject do
      post :create, params: {
        user: {
          email: 'eduardo@example.com',
          password: 'secretsecret'
        }
      }
    end

    it 'should be a json' do
      expect(subject.status).to eq 200
      expect(subject.header['Content-Type']).to include 'application/json'
    end

    it 'should return the created task' do
      expect(subject.body).to eq(User.last.to_json)
    end
  end

  describe '#login' do
    context 'when valid credentials' do
      subject do
        post :login, params: {
          user: { 
            email: 'eduardo.candanedo.94@gmail.com',
            password: 'secretsecret' 
          }
        }
      end

      it 'subject should return 200 and should be a json' do
        expect(subject.status).to eq 200
        expect(subject.header['Content-Type']).to include 'application/json'
      end

      it 'also should return the updated task reflecting changes' do
        expect(JSON.parse(subject.body)['api_token']).to eq(user.api_token)
        expect(JSON.parse(subject.body)['error']).to eq false
      end
    end

    context 'when invalid credentials' do
      subject do
        post :login, params: {
          user: { 
            email: 'eduardo.candanedo.94@gmail.com',
            password: 'random' 
          }
        }
      end

      it 'subject should return 200 and should be as json' do
        expect(subject.status).to eq 200
        expect(subject.header['Content-Type']).to include 'application/json'
      end

      it 'also should return error true with no api_token' do
        expect(JSON.parse(subject.body)['api_token']).to eq(nil)
        expect(JSON.parse(subject.body)['error']).to eq true
      end
    end
  end
end