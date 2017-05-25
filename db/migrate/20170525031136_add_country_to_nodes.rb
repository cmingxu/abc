class AddCountryToNodes < ActiveRecord::Migration[5.0]
  def change
    ["region_code", "tags", "area_code", "latitude", "hostnames", "postal_code", "dma_code", "country_code", "org", "data", "asn", "city", "isp", "longitude", "last_update", "country_code3", "country_name", "ip_str", "os", "ports"].each do |c|
      add_column :nodes, c, :text
    end
  end
end
