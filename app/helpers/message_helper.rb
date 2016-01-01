module MessageHelper
  class Message
    attr_reader :text, :type, :icon

    def initialize(text, type = :danger, icon = :'exclamation-circle')
      @text = text
      @type = type
      @icon = icon
    end
  end

  def all_messages
    models = instance_variables.map{|v| instance_variable_get(v) }.select{|v| v.is_a? ActiveModel::Model}

    messages = []
    messages << Message.new(flash.notice, :info, :'info-circle') if flash.notice.present?
    messages << Message.new(flash.alert) if flash.alert.present?
    models.each do |model|
      model.errors.full_messages.each do |text|
        messages << Message.new(text)
      end
    end

    messages
  end
end
