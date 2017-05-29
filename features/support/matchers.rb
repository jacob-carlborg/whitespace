RSpec::Matchers.define :file_content_eq do |expected|
  match do |actual|
    @expected = expected.dup.force_encoding(Encoding::BINARY)
    @actual = actual.dup.force_encoding(Encoding::BINARY)

    values_match? @expected, @actual
  end

  diffable

  description { "string includes: #{description_of expected}" }
end
