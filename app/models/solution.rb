class Solution < ApplicationRecord

  include AASM

  aasm column: :state do
    state :progress, initial: true
    state :final

    event :mark_final do
      transitions from: :progress, to: :final
    end

  end



  belongs_to :user
  belongs_to :task

  #validations
  validates(:solution, presence: true)


  #callbacks
  before_save :downcase_and_split




  private

  #replace whitespace with separator
  def downcase_and_split

    str = self.name.parameterize(separator: '_')
    self.name = str
  end


end
