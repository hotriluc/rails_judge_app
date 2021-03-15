class SendApprovedSolutionJob < Struct.new(:solution)


  def perform
    # Do something later
    #
    #
    user = solution.user
    task = solution.task
    group = task.group
    path = "/groups/#{group.name}_#{group.id}/#{task.name}_#{task.id}/#{user.name}_#{user.id}_solutions/#{solution.name}_#{solution.id}.json"



    client = DropboxApi::Client.new("CHjiFkO8xAUAAAAAAAAAARV_xG9cvdm81hEqiyNkrxaVdfmb71zUk9ZLye9BfqsM")
    client.upload(path,solution.to_json, {
      autorename: true,
      mode: :overwrite})
  end
end
