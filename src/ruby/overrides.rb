class Hash
  def method_missing(name, *args)
    if name.to_s[-1..-1] == "="
      self[name.to_s[0..-2].to_sym] = args.first
    else
      self[name]
    end
  end

  def symbolize_keys(hash=nil)
    hash||=self
    hash.inject({}){|result, (key, value)|
      new_key = case key
                when String then key.to_sym
                else key
                end
      new_value = case value
                  when Hash then symbolize_keys(value)
                  else value
                  end
      result[new_key] = new_value
      result
    }
  end
end
