SETTINGS_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
INFLUX_CONN = InfluxAdapter.conn
INFLUX_CONN_TDR = InfluxAdapter.conn_tdr

# InfluxDB::Rails.configure do |config|
#   config.influxdb_database = SETTINGS_CONFIG['influxdb']['database']
#   config.influxdb_username = SETTINGS_CONFIG['influxdb']['username']
#   config.influxdb_password = SETTINGS_CONFIG['influxdb']['password']
#   config.influxdb_hosts    = SETTINGS_CONFIG['influxdb']['hosts']
#   config.influxdb_port     = 8086
# end


# InfluxDB::Rails.configure do |config|
#   config.influxdb_database = SETTINGS_CONFIG['influxdb']['database']
#   config.influxdb_username = SETTINGS_CONFIG['influxdb']['username']
#   config.influxdb_password = SETTINGS_CONFIG['influxdb']['password']
#   config.influxdb_hosts    = SETTINGS_CONFIG['influxdb']['hosts']
#   #config.influxdb_hosts    = ["172.17.10.38"]#["172.17.10.30"]#["localhost"]#["172.17.10.29"]
#   # config.influxdb_hosts    = ["localhost"]
#   #config.influxdb_port     = 8083#8086
#   config.influxdb_port     = SETTINGS_CONFIG['influxdb']['port']
#   config.async = true
#   config.logger = Logger.new(STDERR)
#   config.logger.level = Logger::FATAL
#   # config.series_name_for_controller_runtimes = "rails.controller"
#   # config.series_name_for_view_runtimes       = "rails.view"
#   # config.series_name_for_db_runtimes         = "rails.db"
# end


# БД: svp_points
# user: svp
# passw: qir29sir


# class ActiveRecordInfluxDB
#     attr_accessor :table_name
#     #@@table_name = "ticks_232230"#"tdr"
#     #@@table_name = "tdr"
#     # @@table_name = SETTINGS_CONFIG['influxdb']['imei']
#     def initialize(attributes = {})
#       attributes.each do |name, value|
#         self.send("#{name}=", value)
#       end
#       #self.to_s.underscore
      
#       # настройки по умолчанию
#       # InfluxDB::Rails.configure do |config|
#       #   config.influxdb_database = SETTINGS_CONFIG[cfg]['database']
#       #   config.influxdb_username = SETTINGS_CONFIG[cfg]['username']
#       #   config.influxdb_password = SETTINGS_CONFIG[cfg]['password']
#       #   config.influxdb_hosts    = SETTINGS_CONFIG[cfg]['hosts']
#       #   config.influxdb_port     = SETTINGS_CONFIG[cfg]['port']
#       #   config.async = true
#       #   config.logger = Logger.new(STDERR)
#       #   config.logger.level = Logger::FATAL
#       # end
#     end

#     def method_missing(*args, &block)
#       return
#     end

#     def self.client
#       InfluxDB::Rails.client
#     end

#     def self.change_cfg(cfg, imei)
#       if imei.present?
#         InfluxDB::Rails.configure do |config|
#           config.influxdb_database = imei # SETTINGS_CONFIG[cfg]['database']
#           config.influxdb_username = SETTINGS_CONFIG[cfg]['username']
#           config.influxdb_password = SETTINGS_CONFIG[cfg]['password']
#           config.influxdb_hosts    = SETTINGS_CONFIG[cfg]['hosts']
#           config.influxdb_port     = SETTINGS_CONFIG[cfg]['port']
#           config.async = true
#           config.logger = Logger.new(STDERR)
#           config.logger.level = Logger::FATAL
#         end
#       end
#     end

#     # def self.all(conditions = "", imei)
#     #   conditions = " where " + conditions if conditions.present?
#     #   query = "select * from #{imei} #{conditions}"
#     #   Rails.logger.info query
#     #   res = client.query(query)
#     #   records = []
#     #   return [] if res.empty?
#     #   res[ imei ].each do |record_hash|
#     #     records << new(record_hash)
#     #   end
#     #   records
#     # end

#     # def self.where(conditions, imei)
#     #   all(conditions, imei)
#     # end

#     # def self.sum(records, field)
#     #   res = 0
#     #   records.each do |record|
#     #     res += record.send(field)
#     #   end
#     #   res
#     # end

#     # def self.between(field, from, to)
#     #   where("#{field} > '#{from}' and #{field} < '#{to}'")
#     # end

# end

# class ActiveRecordInfluxDBTdr
#     attr_accessor :table_name
#     #@@table_name = "ticks_232230"#"tdr"
#     #@@table_name = "tdr"
#     @@table_name = SETTINGS_CONFIG['tdr']['imei']
#     def initialize(attributes = {})
#       attributes.each do |name, value|
#         self.send("#{name}=", value)
#       end
#       #self.to_s.underscore
#     end

#     def method_missing(*args, &block)
#       return
#     end

#     def self.client
#       InfluxDB::Rails.client
#     end

#     def self.all(conditions = "")
#       conditions = " where " + conditions if conditions.present?
#       query = "select * from #{@@table_name} #{conditions}"
#       Rails.logger.info query
#       res = client.query(query)
#       records = []
#       return [] if res.empty?
#       res[ @@table_name ].each do |record_hash|
#         records << new(record_hash)
#       end
#       records
#     end

#     def self.where(conditions)
#       all(conditions)
#     end

#     def self.sum(records, field)
#       res = 0
#       records.each do |record|
#         res += record.send(field)
#       end
#       res
#     end

#     def self.between(field, from, to)
#       where("#{field} > '#{from}' and #{field} < '#{to}'")
#     end

# end