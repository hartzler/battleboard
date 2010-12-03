class Hash
  def method_missing(name, *args)
    if name.to_s[-1..-1] == "="
      self[name.to_s[0..-2]] = args.first
    else
      self[name.to_s]
    end
  end
end
