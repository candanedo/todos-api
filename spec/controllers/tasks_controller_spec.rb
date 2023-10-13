require 'rails_helper'

describe TasksController do
  let!(:user) { User.create(email: 'eduardo.candanedo.94@gmail.com', password: 'secretsecret') }
  let!(:task_1) { Task.create(title: 'mow the lawn', completed: false, user_id: user.id)}
  let!(:task_2) { Task.create(title: 'pay the bills', completed: false, user_id: user.id)}

  before do
    user.reload
    request.env['HTTP_AUTHORIZATION'] = user.api_token
  end

  describe '#index' do
    before do
      get :index
    end

    it 'should be a json' do
      expect(response.status).to eq 200
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it 'should return all the task that belong to the current user' do
      expect(response.body).to eq([task_1, task_2].to_json)
    end
  end

  describe '#show' do

    before do
      get :show, params: { id: task_1.id }
    end

    it 'should be a json' do
      expect(response.status).to eq 200
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it 'should return all the task that belong to the current user' do
      expect(response.body).to eq(task_1.to_json)
    end
  end

  describe '#create' do
    task_attributes = {
      title: 'go for a run',
      completed: false,
      notes_attributes: [
        {
          content: 'this is a note'
        }
      ]
    }

    before do
      post :create, params: { task: task_attributes }
    end

    it 'should be a json' do
      expect(response.status).to eq 200
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it 'should return the created task' do
      expect(response.body).to eq(user.tasks.last.to_json)
      expect(user.tasks.last.notes.size).to eq 1
    end
  end

  describe '#update' do
    task_attributes = {
      completed: true
    }

    before do
      post :update, params: { id: task_1.id, task: task_attributes }
    end

    it 'should return the updated task reflecting changes' do
      task_1.reload

      expect(response.body).to eq task_1.to_json
    end
  end

  describe '#completed' do
    task_attributes = {
      completed: true
    }

    before do
      task_1.update(completed: true)
      post :completed, params: { id: task_1.id, task: task_attributes }
    end

    it 'should return the updated task reflecting changes' do
      task_1.reload

      expect(response.body).to eq [task_1].to_json
    end
  end

  describe '#destroy' do
    before do
      task_1.update(completed: true)
      delete :destroy, params: { id: task_1.id }
    end

    it 'should delete given task' do
      expect(response.body).to eq(
        { 'error': false, 'message': 'Successfully deleted task' }.to_json
      )
    end

    it 'should show at db level a record less' do
      expect(user.tasks.size).to eq(1)
    end
  end
end
