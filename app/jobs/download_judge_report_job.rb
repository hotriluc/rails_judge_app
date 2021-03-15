class DownloadJudgeReportJob < Struct.new(:solution)


  def perform
    #to authenticate on rapidApi
    auth = {"x-rapidapi-key":  'ef1458feb2msh5cde710ff61a688p128d3fjsnc54b06694895'}
    url = "https://judge0-ce.p.rapidapi.com/submissions/#{solution.judge_token}?base64_encoded=false"
    response = RestClient.get(url, headers=auth)
    puts response.body

  end
end
