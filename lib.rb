require 'curb'
require 'json'

def get_doors_list(key)
  kisi_url = "https://my.getkisi.com/api/locks/index_with_token.json?limit=10&offset=0&token=#{key}"

  response = Curl::Easy.http_get(kisi_url) do |curl|
    curl.headers["Content-Type"] = "application/json;charset=UTF-8"
    curl.headers["Accept"] = "application/json, text/plain, */*"
  end

  JSON.parse response.body_str
end

def unlock_door(door, key)
  kisi_url = "https://my.getkisi.com/api/locks/#{door["id"]}/access_with_token.json?token=#{key}"
  door_body = "{\"lock\":#{door.to_json}}"

  Curl::Easy.http_post(kisi_url, door_body) do |curl|
    curl.headers["Content-Type"] = "application/json;charset=UTF-8"
    curl.headers["Accept"] = "application/json, text/plain, */*"
  end
end
