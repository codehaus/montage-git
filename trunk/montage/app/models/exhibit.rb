class Exhibit < ActiveRecord::Base
  def to_s
    "Exhibit[id=#{id}, title=#{title}]"
  end
end
