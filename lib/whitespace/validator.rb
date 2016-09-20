module Whitespace
  class Validator < Base
    Line = Struct.new(:filename, :line, :number) do
      def initialize(filename, line, number)
        self.filename = filename
        self.line = line.force_encoding(Encoding::BINARY)
        self.number = number
      end

      def to_diagnostic
        "#{filename}:#{number}:#{highlighted_line}"
      end

      private

      def highlighted_line
        line.gsub(/( +)$/, "\033[101m\\1\033[0m")
      end
    end

    class File < Base::File
      def grep
        ::File.readlines(filename)
          .map.with_index { |l, n| Line.new(filename, l, n + 1) }
          .select { |e| Base::TRAILING_WHITESPACE_PATTERN.match(e.line) }
      end
    end

    private_constant :Line
    private_constant :File

    def invoke
      print_diagnostics(validate)
    end

    def validate
      path = ::File.join(self.path, '**/*')
      Dir.glob(path)
        .map { |e| File.new(e, config.ignored_paths) }
        .select(&:file?)
        .reject(&:ignore?)
        .flat_map(&:grep)
        .map(&:to_diagnostic)
    end

    def print_diagnostics(validation_result)
      validation_result.each { |line| puts line }
      exit validation_result.empty? ? 0 : 1
    end
  end
end
