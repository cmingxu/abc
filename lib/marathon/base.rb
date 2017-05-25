# Base class for all the API specific classes.
class Marathon::Base

  include Marathon::Error

  attr_reader :info

  # Create the object
  # ++hash++: object returned from API. May be Hash or Array.
  # ++attr_accessors++: List of attribute accessors.
  def initialize(hash, attr_accessors = [])
    raise ArgumentError, 'hash must be a Hash' if attr_accessors and attr_accessors.size > 0 and not hash.is_a?(Hash)
    raise ArgumentError, 'hash must be Hash or Array' unless hash.is_a?(Hash) or hash.is_a?(Array)
    raise ArgumentError, 'attr_accessors must be an Array' unless attr_accessors.is_a?(Array)
    @info = Marathon::Util.keywordize_hash!(hash)
    attr_accessors.each { |e| add_attr_accessor(e) }
  end

  # Return application as JSON formatted string.
  def to_json(opts = {})
    info.to_json(opts)
  end

  private

  # Create attr_accessor for @info[key].
  # ++key++: key in @info
  def add_attr_accessor(key)
    sym = key.to_sym
    self.class.send(:define_method, sym.id2name) { info[sym] }
    self.class.send(:define_method, "#{sym.id2name}=") { |v| info[sym] = v }
  end
end
