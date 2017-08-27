class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.is_student?
      email = value.split('@')
      if WhitelistEmailDomain.all.map(&:description).exclude?(email[1])
        record.errors[attribute] << (options[:message] || 'domain invalid for students')
      end
    end
  end
end
