module VerifiedDouble
  class ExampleMetadata < Struct.new(:metadata)
    def described_class
      if description.is_a?(Module)
        description
      elsif description.is_a?(String)
        ExampleMetadata.new(metadata[:example_group]).described_class
      else
        raise
      end
    end

    def description
      metadata[:description_args][0]
    end

    def method_signature_string
      if description =~ /^[\.\#]/
        description
      elsif description.nil?
        raise
      else
        ExampleMetadata.new(metadata[:example_group]).method_signature_string
      end
    end

    def verified_signature
      "#{described_class}#{method_signature_string}"
    end
  end
end
