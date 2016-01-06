class Admin::CurrentUserPresenter
  ATTR_MAP = {
    first_name:   :eduPersonNickname,
    last_name:    :sn,
    email:        :mail,
    photo_url:    :url,
    affiliations: [:eduPersonAffiliation],
    entitlements: [:eduPersonEntitlement]

  }

  attr_reader :username
  attr_reader *ATTR_MAP.keys

  def initialize(session)
    @session = session

    if session_valid?
      @username = session['cas']['user']

      ATTR_MAP.each do |att, cas_att|
        value = if cas_att.is_a? Array
          extra_attr(cas_att.first)
        else
          extra_attr(cas_att.to_s).try(:first)
        end

        instance_variable_set "@#{att}", value
      end
    end
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  def authenticated?
    !username.nil?
  end

  def admin?
    relevant_entitlements.include? 'admin'
  end

  def developer?
    relevant_entitlements.include? 'developer'
  end

  private

  attr_reader :session

  def session_valid?
    session.has_key?('cas') && session['cas'].has_key?('user') && session['cas'].has_key?('extra_attributes')
  end

  def extra_attr(key)
    session['cas']['extra_attributes'][key.to_s]
  end

  # Find URNs that match the namespaces and remove the namespace
  # See http://en.wikipedia.org/wiki/Uniform_Resource_Name
  def relevant_entitlements
    urns = Array(entitlements)
    nids = Settings.urn_namespaces

    return [] if urns.blank?

    clean_urns = urns.map { |e| e.gsub(/^urn:/i, '') }
    clean_nids = nids.map { |n| n.gsub(/^urn:/i, '') }

    clean_urns.map { |urn|
      clean_nids.map { |nid|
        urn[0...nid.length] == nid ? urn[nid.length..urn.length] : nil
      }
    }.flatten.compact
  end
end
