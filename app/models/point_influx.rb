class Point # < ActiveRecordInfluxDB
  attr_accessor :time, :lat, :lon, :transport_id
  # TIME_SERIES_NAME = "svp_points"
  # TIME_SERIES_NAME = "ticks_232230"
  # TIME_SERIES_NAME = SETTINGS_CONFIG['influxdb']['imei']

  def self.search(search, imei)
    if imei.present?
      p "imei present"
      if search
        # в инфлюксе нет оператора >= или аналогичный
        date_from = (DateTime.parse(search[:date_from]).to_i - 24*60*60)*1000000 if search[:date_from].present?
        date_to = (DateTime.parse(search[:date_to]).to_i + 24*60*60)*1000000 if search[:date_to].present?

        if search[:date_from].present? && search[:date_to].present? 
          get_data(" and time > #{date_from} and time < #{date_to}", imei)
        elsif search[:date_from].present? && search[:date_to].blank?
          get_data(" and time > #{date_from}", imei)
        elsif search[:date_from].blank? && search[:date_to].present?
          get_data(" and time < #{date_to}", imei)
        else
          get_data("", imei)
        end
      else
        get_data("", imei)
      end
    else
      p "imei nil"
      return nil
    end
  end

  def self.get_data(conditions="", imei)    
    result = {:points => [], :begin_point => nil, :end_point => nil, :tdr_sum => 0, :tdr_path => 0}
    begin
      p query = "select * from #{SETTINGS_CONFIG['influxdb']['series']} where imei=#{imei} #{conditions} limit 100 order asc"
      res = INFLUX_CONN.query query
      result[:points] = res[SETTINGS_CONFIG['influxdb']['series']]
      if res.present? && result[:points].size > 0
        result[:begin_point] = result[:points].first
        result[:end_point] = result[:points].last
      end
    rescue Exception => e
      puts "ERROR! #{e}"
    end
    result
  end

  # def self.get_data(conditions = "", imei)
  #   # TIME_SERIES_NAME = "ticks_#{imei}"
  #   if imei.present?
  #     time_series_name_imei = "ticks_#{imei}"

  #     change_cfg('influxdb', time_series_name_imei)

  #     conditions = " where " + conditions if conditions.present?
  #     query = "select * from #{time_series_name_imei} #{conditions}"
  #     result = {:points => [], :begin_point => nil, :end_point => nil, :tdr_sum => 0, :tdr_path => 0}
  #     Rails.logger.info query
  #     res = client.query(query)
  #     return result if res.empty?
  #     res[ time_series_name_imei ].each do |record_hash|
  #       result[:points] << new(record_hash)
  #     end
  #     result[:begin_point], result[:end_point] = result[:points].first, result[:points].last
  #     return result
  #   else
  #     return nil
  #   end
  # end



  # def self.generate(delete_all = false)
  #   client.query("delete from #{TIME_SERIES_NAME}")# if delete_all
  #   client.query("delete from tdr")
  #   transports = ["10000", "10001", "10002", "10003", "10004"]
  #   file = File.read('test_path.json')
  #   data = JSON.parse file

  #   puts data.size

  #   duration = 10
  #   _time = (DateTime.now - duration.day).strftime("%Q").to_i

  #   points_count = data.size

  #   point_per_time = duration*24*3600/points_count

  #   data.each_with_index do |point, i|
  #     time_from = Time.now - rand(1..10).send(["hour", "day"].sample)
  #     time_to = Time.now
  #     distance = rand(1..10)
  #     ts = transports.sample
  #     price = distance * rand(50..100)
  #     data = {
  #         "time_from" => time_from.to_i, "time_to" => time_to.to_i, "price" => price, "transport_id" => ts,
  #         "distance" => distance
  #     }

  #     client.write_point("tdr", data)


  #     time = _time
  #     lat = point["lat"]
  #     lon = point["lon"]
  #     transport_id = transports.sample
  #     data_write = {
  #         time: (_time/1000).to_i, lat: lat, lon: lon, transport_id: ts
  #     }
  #     puts data_write.inspect
  #     p point
  #     # client.write_point("svp_points", data_write)

  #     _time += point_per_time.second
  #   end
  #   puts "OK"
  # end

  def to_s
    "#{lat}, #{lon}"
  end
end