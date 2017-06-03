require 'net/ssh'

class Node < ApplicationRecord
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

end
