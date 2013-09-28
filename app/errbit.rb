class Errbit
  def initialize(params = {}, &block)
    raise "No server." unless @server = params[:server]
    raise "No username." unless username = params[:username]
    raise "No password." unless password = params[:password]

    credentials = {user: {email: username, password: password}}
    BW::HTTP.post("#{@server}users/sign_in", {payload: credentials}) do |response|
      if response.ok?
        block.call if block
      else
        App.alert("Could not connect to server.")
      end
    end
  end

  def base_url
    "#{@server}api/v1/"
  end

  def get_feed(end_point, &block)
    fetch_url = "#{base_url}#{end_point}"
    BW::HTTP.get("#{fetch_url}", {cookie: true }) do |response|
      if response.ok?
        json = BW::JSON.parse(response.body.to_str).sort_by{|i| i['last_notice_at']}.reverse
        block.call(json)
      else
        App.alert("Could not fetch feed.")
      end
    end
  end

  def problems(&block)
    get_feed("problems.json") do |json|
      if block
        block.call(json)
      else
        return json
      end
    end
  end
end
