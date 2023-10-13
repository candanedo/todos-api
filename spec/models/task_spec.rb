require 'rails_helper'

RSpec.describe Task, type: :model do
  it { is_expected.to have_many(:notes) }

  describe '#scopes' do
    let!(:user) { User.create(email: 'eduardo.candanedo.94@gmail.com', password: 'secretsecret') }
    let!(:task_1) do
      user.tasks.create(title: 'mow the lawn', completed: false, user_id: user.id)
    end

    let!(:task_2) do
      user.tasks.create(title: 'pay the bills', completed: true, user_id: user.id)
    end

    context 'completed' do
      it 'should only return completed tasks' do
        expect(user.tasks.completed).to eq([task_2])
      end
    end

    context 'uncompleted' do
      it 'should only return uncompleted tasks' do
        expect(user.tasks.uncompleted).to eq([task_1])
      end
    end
  end
end
