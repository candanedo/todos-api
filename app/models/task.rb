class Task < ApplicationRecord
  include Filterable

  belongs_to :user
  has_many :notes, inverse_of: :task

  accepts_nested_attributes_for :notes

  scope :completed, -> { where(completed: true) }
  scope :uncompleted, -> { where(completed: false) }
  scope :by_completed, -> (filter) { where(completed: filter) }
end
