class Solution < ApplicationRecord

  include AASM

  aasm column: :state do
    state :progress, initial: true
    state :final, :approved, :disapproved

    event :mark_final do
      before do
        p "Current state of the solution is: #{state}"
      end

      after do
        p "New state of the solution is: #{state}"
      end

      transitions from: [:progress], to: :final
    end

    event :disapprove do
      transitions from: :final, to: :progress
    end

    event :approve do
      transitions from: :final, to: :approved, after: :send_to_drop_box
    end

  end



  belongs_to :user
  belongs_to :task

  #validations
  validates(:solution, presence: true)

  #callbacks
  before_save :downcase_and_split



  def send_to_drop_box
    p 'send to drop_box'
  end


  def correct_creator?(user)
    user.id == self.user_id
  end

  private

  #replace whitespace with separator
  def downcase_and_split

    str = self.name.parameterize(separator: '_')
    self.name = str
  end


end
