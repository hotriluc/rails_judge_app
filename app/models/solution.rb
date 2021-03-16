class Solution < ApplicationRecord
  require 'zip'
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





  #Getting submission with judge_token
  def download
    auth = {"x-rapidapi-key":  'ef1458feb2msh5cde710ff61a688p128d3fjsnc54b06694895'}
    url = "https://judge0-ce.p.rapidapi.com/submissions/#{self.judge_token}?base64_encoded=false"
    response = RestClient.get(url, headers=auth)
    report = response.body
  end

  def self.download_zip(solutions)

    file = "archive.zip"

    Zip::File.open(file, Zip::File::CREATE) do |zipfile|
      solutions.each do |solution|
        File.open("#{solution.name}_#{solution.id}.json", 'w') { |f| f.write(solution.to_json) }

        zipfile.add("#{solution.name}_#{solution.id}.json", "#{solution.name}_#{solution.id}.json")
      end
    end
    zip_data = File.read(file)
  end


  def judge
    #to authenticate on rapidApi
    auth = {"x-rapidapi-key":  'ef1458feb2msh5cde710ff61a688p128d3fjsnc54b06694895'}

    #submission to judge url
    url = "https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=false"


    #assume that all solutions are written in Ruby
    # (language_id 72 = Ruby according to the Judge0 spec)
    response = RestClient.post(url, {language_id:72, source_code: self.solution}, headers=auth)

    data = JSON.parse(response.body)
    puts data
    # update judge_token attribute on solution
    self.update_attribute(:judge_token, data["token"])

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
