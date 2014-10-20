class Point < ActiveRecord::Base

  def self.search(search, imei)
    if imei.present?
      p "imei present"
      result = Point.where(imei: imei)

      if search
        date_from = DateTime.parse(search[:date_from]).to_i if search[:date_from].present?
        date_to = DateTime.parse(search[:date_to]).to_i if search[:date_to].present?
        

        if search[:date_from].present? && search[:date_to].present? 
          return result.where("time >= ? and time <= ?", date_from, date_to)
        elsif search[:date_from].present? && search[:date_to].blank?
          return result.where("time >= ? ", date_from)
        elsif search[:date_from].blank? && search[:date_to].present?
          return result.where("time <= ?", date_to)
        else
          return result
        end
      else
        return result
      end
    else
      p "imei nil"
      return nil
    end
  end

end