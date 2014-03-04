module VerifiedDouble
  class ExampleMetadata < Struct.new(:metadata)
    def described_class
      if description.is_a?(Module)
        description
      elsif !metadata[:example_group].nil?
        ExampleMetadata.new(metadata[:example_group]).described_class
      else
        raise StandardError,
          "The VerifiedDouble contract spec described class '#{description}' is
            invalid. The described class must be a class or a module."
            .gsub(/\s+/, ' ')
      end
    end

    def description
      metadata[:description_args][0]
    end

    def method_signature_string
      if description =~ /^[\.\#]/
        description
      elsif metadata[:example_group].nil?
        raise StandardError,
          "The VerifiedDouble contract spec method '#{description}' is invalid.
            The method must start with # or ."
            .gsub(/\s+/, ' ')
      else
        ExampleMetadata.new(metadata[:example_group]).method_signature_string
      end
    end

    def verified_signature
      "#{described_class}#{method_signature_string}"
    end
  end
end
