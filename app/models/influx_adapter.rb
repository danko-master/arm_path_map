class InfluxAdapter
  def self.conn
    InfluxDB::Client.new(SETTINGS_CONFIG['influxdb']['database'], 
      :hosts => SETTINGS_CONFIG['influxdb']['hosts'],
      :username => SETTINGS_CONFIG['influxdb']['username'], 
      :password => SETTINGS_CONFIG['influxdb']['password'])
  end

  def self.conn_tdr
    InfluxDB::Client.new(SETTINGS_CONFIG['tdr']['database'], 
      :hosts => SETTINGS_CONFIG['tdr']['hosts'],
      :username => SETTINGS_CONFIG['tdr']['username'], 
      :password => SETTINGS_CONFIG['tdr']['password'])
  end
end