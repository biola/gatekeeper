class TrogdirPerson
  def initialize(id, type = :uuid)
    @id = id
    @type = type
  end

  def uuid
    data[:uuid]
  end

  def preferred_name
    data[:preferred_name]
  end

  def last_name
    data[:last_name]
  end

  def name
    [preferred_name, last_name].reject(&:blank?).join (' ')
  end

  def email
    data[:emails].to_a.find { |e| e[:type] == 'university' }.try :[], :address
  end

  def biola_id
    data[:ids].to_a.find { |e| e[:type] == 'biola_id' }.try :[], :identifier
  end

  def netid
    data[:ids].to_a.find { |e| e[:type] == 'netid' }.try :[], :identifier
  end

  def photo_url
    data[:photos].to_a.find { |e| e[:type] == 'id_card' }.try :[], :url
  end

  private

  attr_reader :id, :type

  def data
    @data ||= (
      meth, params = if type.to_s == 'uuid'
        [:show, uuid: id]
      else
        [:by_id, type: type, id: id]
      end

      Trogdir::APIClient::People.new.send(meth, params).perform.parse.with_indifferent_access
    )
  end
end
