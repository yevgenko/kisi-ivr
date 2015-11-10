require 'curb'
require 'json'

app = -> (env) do
  req = Rack::Request.new(env)
  puts req.body.read

  params = JSON.parse(req.body.read)
  puts params['From']

  kisi_url = "https://my.getkisi.com/api/locks/1933/access_with_token.json?token=#{ENV['KISI_TOKEN']}"
  door_body = '{"lock":{"channel":5,"gateway_id":2284,"id":1933,"place_id":1372}}'
  Curl::Easy.http_post(kisi_url, door_body) do |curl|
    curl.headers["Content-Type"] = "application/json;charset=UTF-8"
    curl.headers["Accept"] = "application/json, text/plain, */*"
  end
  response = <<-EOH
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>Welcome!</Say>
  <Hangup />
</Response>
  EOH

  [200, { "Content-Type" => "text/xml" }, [response]]
end

run app
