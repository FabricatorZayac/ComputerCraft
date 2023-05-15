while true do
  http.request("http://localhost:8080/stream")

  local requesting = true

  while requesting do
    local event, _, sourceText = os.pullEvent()

    if event == "http_success" then
      local respondedText = sourceText.readLine()
      sourceText.close()
      print(respondedText)
      requesting = false
    elseif event == "http_failure" then
      print("Server didn't respond.")
      requesting = false
    end
  end
end
