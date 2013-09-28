class Errbit
  def initialize(params = {}, &block)
    raise "No server." unless @server = params[:server]
    raise "No username." unless username = params[:username]
    raise "No password." unless password = params[:password]

    getCSRF do |csrf|
      credentials = {user: {email: username, password: password}, authenticity_token: csrf}
      BW::HTTP.post("#{@server}users/sign_in", {payload: credentials, cookie: true }) do |response|
        if response.ok?
          block.call if block
        else
          App.alert("Could not connect to server.")
        end
      end
    end
  end

  def base_url
    "#{@server}api/v1/"
  end

  def getCSRF(&block)
    BW::HTTP.get("#{@server}users/sign_in", { cookie: true }) do |response|
      if response.ok?
        csrf_matches = response.body.to_str.scan(/authenticity_token" type="hidden" value="([^"]*)"/)
        if csrf_matches.count > 0
          block.call csrf_matches[0][0] if block
        else
          block.call nil if block
        end
      else
        App.alert("Could not connect to server.")
      end
    end
  end

  def get_feed(end_point, &block)
    fetch_url = "#{base_url}#{end_point}"
    BW::HTTP.get("#{fetch_url}", {cookie: true }) do |response|
      if response.ok?
        json_string = response.body.to_str.dataUsingEncoding(NSUTF8StringEncoding)
        e = Pointer.new(:object)
        json_hash = NSJSONSerialization.JSONObjectWithData(json_string, options:0, error: e).sort_by{|i| i['last_notice_at']}.reverse
        block.call(json_hash)
      elsif response.status_code.to_s =~ /404/
        App.alert("API is not supported on the server.")
      elsif response.status_code.to_s =~ /40\d/
        App.alert("Login failed")
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
