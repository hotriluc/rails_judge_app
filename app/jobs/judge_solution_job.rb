class JudgeSolutionJob < Struct.new(:solution)


  def perform

    #to authenticate on rapidApi
    auth = {"x-rapidapi-key":  'ef1458feb2msh5cde710ff61a688p128d3fjsnc54b06694895'}

    #submission to judge url
    url = "https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=false"


    #assume that all solutions are written in Ruby
    # (language_id 72 = Ruby according to the Judge0 spec)
    response = RestClient.post(url, {language_id:72, source_code: solution.solution}, headers=auth)

    data = JSON.parse(response.body)

    # update judge_token attribute on solution
    solution.update_attribute(:judge_token, data["token"])

    # url = "https://judge0-ce.p.rapidapi.com/submissions/#{data["token"]}?base64_encoded=false"
    # response = RestClient.get(url, headers=auth)
    # puts response.body

  end
end
