class Solution < ApplicationRecord
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
