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
      transitions from: :final, to: :approved
    end

  end



  belongs_to :user
  belongs_to :task

  #validations
  validates(:solution, presence: true)

  #callbacks
  before_save :downcase_and_split

  def self.download_zip(solutions)
    solutions.each do |solution|

    end
  end



  def say_solution_name
    puts "======================="
    puts "I am solution #{self.name} my id: #{self.id}"
    puts self.to_json
    puts "======================="
  end
  # handle_asynchronously :say_solution_name, :run_at => Proc.new { 30.seconds.from_now }

  #getting submission with judge_token
  def download
    auth = {"x-rapidapi-key":  'ef1458feb2msh5cde710ff61a688p128d3fjsnc54b06694895'}
    url = "https://judge0-ce.p.rapidapi.com/submissions/#{self.judge_token}?base64_encoded=false"
    response = RestClient.get(url, headers=auth)
    report = response.body
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
