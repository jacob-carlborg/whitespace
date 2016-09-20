module Whitespace
  class Validator
    IGNORED_PATHS = %w(vendor .git tmp log coverage).freeze
    TRAILING_WHITESPACE_PATTERN = / +$/

    Line = Struct.new(:filename, :line, :number) do
      def line
        self['line'].force_encoding(Encoding::BINARY)
      end

      def to_diagnostic
        "#{filename}:#{number}:#{highlighted_line}"
      end

      private

      def highlighted_line
        line.gsub(/( +)$/, "\033[101m\\1\033[0m")
      end
    end

    class ValidatingFile
      attr_reader :filename

      def initialize(filename)
        @filename = filename
      end

      def file?
        File.file?(filename)
      end

      def ignore?
        !IGNORED_PATHS.find { |e| filename.start_with?(e) }.nil?
      end

      def grep
        File.readlines(filename)
          .map.with_index { |l, n| Line.new(filename, l, n + 1) }
          .select { |e| TRAILING_WHITESPACE_PATTERN.match(e.line) }
      end
    end

    private_constant :IGNORED_PATHS
    private_constant :TRAILING_WHITESPACE_PATTERN
    private_constant :Line
    private_constant :ValidatingFile

    def self.validate(path)
      validator = new(path)
      validator.print_diagnostics(validator.validate)
    end

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def validate
      path = File.join(self.path, '**/*')
      Dir.glob(path)
        .map { |e| ValidatingFile.new(e) }
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
