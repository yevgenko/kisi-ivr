require 'curb'

app = -> (env) do
  req = Rack::Request.new(env)

  if req.post? && req.params['From'].include?(ENV['PHONE'])
    kisi_url = "https://my.getkisi.com/api/locks/1933/access_with_token.json?token=#{ENV['KISI_TOKEN']}"
    door_body = '{"lock":{"channel":5,"gateway_id":2284,"id":1933,"place_id":1372}}'

    Curl::Easy.http_post(kisi_url, door_body) do |curl|
      curl.headers["Content-Type"] = "application/json;charset=UTF-8"
      curl.headers["Accept"] = "application/json, text/plain, */*"
    end

    greeting = "Welcome!"
  else
    greeting = "Sorry, you are not authorized to access this permisse!"
  end

  response = <<-EOH
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>#{greeting}</Say>
  <Hangup />
</Response>
  EOH

  [200, { "Content-Type" => "text/xml" }, [response]]
end

run app
