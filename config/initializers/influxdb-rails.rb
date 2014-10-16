InfluxDB::Rails.configure do |config|
  #config.influxdb_database = "svp_points"
  config.influxdb_database = "svp"
  #config.influxdb_username = "svp"
  config.influxdb_username = "rails"
  #config.influxdb_password = "qir29sir"
  config.influxdb_password = "rails"
  #config.influxdb_hosts    = ["172.17.10.38"]#["172.17.10.30"]#["localhost"]#["172.17.10.29"]
  config.influxdb_hosts    = ["localhost"]
  #config.influxdb_port     = 8083#8086
  config.influxdb_port     = 8086
  config.async = true
  config.logger = Logger.new(STDERR)
  config.logger.level = Logger::FATAL
  # config.series_name_for_controller_runtimes = "rails.controller"
  # config.series_name_for_view_runtimes       = "rails.view"
  # config.series_name_for_db_runtimes         = "rails.db"
end
# БД: svp_points
# user: svp
# passw: qir29sir


class ActiveRecordInfluxDB
    attr_accessor :table_name
    #@@table_name = "ticks_232230"#"tdr"
    @@table_name = "tdr"
    def initialize(attributes = {})
      attributes.each do |name, value|
        self.send("#{name}=", value)
      end
      #self.to_s.underscore
    end

    def method_missing(*args, &block)
      return
    end

    def self.client
      InfluxDB::Rails.client
    end

    def self.all(conditions = "")
      conditions = " where " + conditions if conditions.present?
      query = "select * from #{@@table_name} #{conditions}"
      Rails.logger.info query
      res = client.query(query)
      records = []
      return [] if res.empty?
      res[ @@table_name ].each do |record_hash|
        records << new(record_hash)
      end
      records
    end

    def self.where(conditions)
      all(conditions)
    end

    def self.sum(records, field)
      res = 0
      records.each do |record|
        res += record.send(field)
      end
      res
    end

    def self.between(field, from, to)
      where("#{field} > '#{from}' and #{field} < '#{to}'")
    end

end