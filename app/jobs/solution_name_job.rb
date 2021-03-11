class SolutionNameJob < Struct.new(:solution)


  def perform
    client = DropboxApi::Client.new("Re0v0X7mKfAAAAAAAAAAAQyl3o5ZeOWwTFFafxsJqIPT-642fytbmKpr--f1PFLe")

    solution.say_solution_name
    Delayed::Job.enqueue SolutionNameJob.new(solution), 1, 30.seconds.from_now
  end

end
