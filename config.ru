require 'kisi/client'

KISI_TOKEN = ENV['KISI_TOKEN']
PHONE = ENV['PHONE']

def kisi
  @kisi ||= Kisi::Client.new KISI_TOKEN
end

app = -> (env) do
  req = Rack::Request.new(env)

  if req.post? && req.params['From'].include?(PHONE)
    if req.params['Digits']
      doors = kisi.get_doors
      door = doors[req.params['Digits'].to_i - 1]
      greeting = if door
                   kisi.open_door(door)
                   "Welcome!"
                 else
                   "Can't find the door!"
                 end
      response = <<-EOH
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>#{greeting}</Say>
  <Hangup />
</Response>
      EOH
    else
      greeting = "Welcome!"
      doors = kisi.get_doors
      doors.each_with_index do |current_door, i|
        greeting << "To open #{current_door["name"]}, press #{i+1}."
      end
      response = <<-EOH
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Gather numDigits="1">
    <Say>#{greeting}</Say>
  </Gather>
</Response>
      EOH
    end
  end

  # default response
  unless response
    response = <<-EOH
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>Sorry, you are not authorized to access this premise!</Say>
  <Hangup />
</Response>
    EOH
  end

  [200, { "Content-Type" => "text/xml" }, [response]]
end

run app
