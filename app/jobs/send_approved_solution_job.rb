class SendApprovedSolutionJob < Struct.new(:solution)


  def perform
    # Do something later
    #
    #
    user = solution.user
    task = solution.task
    group = task.group
    path = "/groups/#{group.name}_#{group.id}/#{task.name}_#{task.id}/#{user.name}_#{user.id}_solutions/#{solution.name}_#{solution.id}.json"

    # Get submission from judge0
    auth = {"x-rapidapi-key":  'ef1458feb2msh5cde710ff61a688p128d3fjsnc54b06694895'}
    url = "https://judge0-ce.p.rapidapi.com/submissions/#{solution.judge_token}?base64_encoded=false"
    response = RestClient.get(url, headers=auth)
    data = response.body

    # data = solution.solution

    # Save the report to Dropbox
    client = DropboxApi::Client.new("CHjiFkO8xAUAAAAAAAAAARV_xG9cvdm81hEqiyNkrxaVdfmb71zUk9ZLye9BfqsM")
    client.upload(path,data, {
      autorename: true,
      mode: :overwrite})
  end
end
