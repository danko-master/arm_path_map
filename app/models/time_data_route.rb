class TimeDataRoute # < ActiveRecordInfluxDB
  attr_accessor :sequence_number, :time, :time_from, :time_to, :price, :transport_id, :distance
  TIME_SERIES_NAME = "svp_tdr"

  def self.search(search, imei)
    if imei.present?
      if search
        # date_from = (search[:date_from].present? ? search[:date_from] : Time.now).to_datetime.to_i
        # date_to = (search[:date_to].present? ? search[:date_to] : Time.now).to_datetime.to_i
        # transport_id = search[:transport_id]
        
        # в инфлюксе нет оператора >= или аналогичный
        date_from = (DateTime.parse(search[:date_from]).to_i - 24*60*60)*1000000 if search[:date_from].present?
        date_to = (DateTime.parse(search[:date_to]).to_i + 24*60*60)*1000000 if search[:date_to].present?

        if search[:date_from].present? && search[:date_to].present? 
          get_total_price_and_distance(" and time > #{date_from} and time < #{date_to}", imei)
        elsif search[:date_from].present? && search[:date_to].blank?
          get_total_price_and_distance(" and time > #{date_from}", imei)
        elsif search[:date_from].blank? && search[:date_to].present?
          get_total_price_and_distance(" and time < #{date_to}", imei)
        else
          get_total_price_and_distance("", imei)
        end

        # get_total_price_and_distance("transport_id = '#{transport_id}' AND (time_from >= #{date_from} and time_from <= #{date_to}) OR (time_to >= #{date_from} and time_to <= #{date_to})")
      else
        get_total_price_and_distance("", imei)
      end
    else
      return nil
    end
  end
  
  def self.get_total_price_and_distance(conditions = "", imei)
    result = {:total_price => 0, :total_distance => 0}
    begin
      p query = "select * from #{SETTINGS_CONFIG['tdr']['series']} where imei=#{imei} #{conditions} limit 100 order asc"
      res = INFLUX_CONN_TDR.query query
      if res.present? && res[SETTINGS_CONFIG['tdr']['series']].size > 0
        res[SETTINGS_CONFIG['tdr']['series']].each do |record_hash|
          p record_hash
          result[:total_price] += record_hash["sum"].to_i
          result[:total_distance] += record_hash["path"].to_i
        end
      end
    rescue Exception => e
      puts "ERROR! #{e}"
    end
    result
  end

  # def self.get_total_price_and_distance(conditions = "")
  #   change_cfg("tdr")

  #   conditions = ""#{}" where " + conditions if conditions.present?
  #   query = "select * from #{TIME_SERIES_NAME} #{conditions}"
  #   result = {:total_price => 0, :total_distance => 0}
  #   Rails.logger.info query
  #   res = client.query(query)
  #   return result if res.empty?
  #   res[ TIME_SERIES_NAME ].each do |record_hash|
  #     result[:total_price] += record_hash["sum"].to_i
  #     result[:total_distance] += record_hash["path"].to_i
  #   end
  #   return result
  # end


end




# 1413198336	1413205536
#select * from tdr where (time_from > '1413198336' AND time_from < '1413198336') OR (time_to > '' AND time_to < '')