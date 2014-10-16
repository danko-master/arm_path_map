class Point < ActiveRecordInfluxDB
  attr_accessor :time, :lat, :lon, :transport_id
  TIME_SERIES_NAME = "svp_points"
  #TIME_SERIES_NAME = "ticks_232230"

  def self.search(search)
    if search
      date_from = (search[:date_from].present? ? search[:date_from] : Time.now).to_date
      date_to = (search[:date_to].present? ? search[:date_to] : Time.now).to_date
      transport_id = search[:transport_id]
      get_data("transport_id = '#{transport_id}' AND time > '#{date_from}' and time < '#{date_to}'")
    else
      get_data
    end
  end


  def self.get_data(conditions = "")
    conditions = " where " + conditions if conditions.present?
    query = "select * from #{TIME_SERIES_NAME} #{conditions}"
    result = {:points => [], :begin_point => nil, :end_point => nil }
    Rails.logger.info query
    res = client.query(query)
    return result if res.empty?
    res[ TIME_SERIES_NAME ].each do |record_hash|
      result[:points] << new(record_hash)
    end
    result[:begin_point], result[:end_point] = result[:points].first, result[:points].last
    return result
  end

  def self.generate(delete_all = false)
    client.query("delete from #{TIME_SERIES_NAME}")# if delete_all
    client.query("delete from tdr")
    transports = ["10000", "10001", "10002", "10003", "10004"]
    file = File.read('test_path.json')
    data = JSON.parse file

    puts data.size

    duration = 10
    _time = (DateTime.now - duration.day).strftime("%Q").to_i

    points_count = data.size

    point_per_time = duration*24*3600/points_count

    data.each_with_index do |point, i|
      time_from = Time.now - rand(1..10).send(["hour", "day"].sample)
      time_to = Time.now
      distance = rand(1..10)
      ts = transports.sample
      price = distance * rand(50..100)
      data = {
          "time_from" => time_from.to_i, "time_to" => time_to.to_i, "price" => price, "transport_id" => ts,
          "distance" => distance
      }

      client.write_point("tdr", data)


      time = _time
      lat = point["lat"]
      lon = point["lon"]
      transport_id = transports.sample
      data_write = {
          time: (_time/1000).to_i, lat: lat, lon: lon, transport_id: ts
      }
      puts data_write.inspect
      p point
      client.write_point("svp_points", data_write)

      _time += point_per_time.second
    end
    puts "OK"
  end

  def to_s
    "#{lat}, #{lon}"
  end
end