class SolutionNameJob < Struct.new(:solution)


  def perform
    solution.say_solution_name
    Delayed::Job.enqueue SolutionNameJob.new(solution), 1, 30.seconds.from_now
  end

end
