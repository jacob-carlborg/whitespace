module Whitespace
  class Validator
    TRAILING_WHITESPACE_PATTERN = / +$/

    Config = Struct.new(:ignored_paths) do
      DEFAULT_IGNORED_PATHS = %w(.git .svn .hg).freeze

      def initialize(options)
        options.each { |option, value| self[option] = value }
        set_ignored_paths!
      end

      private

      def set_ignored_paths!
        paths = DEFAULT_IGNORED_PATHS + ignored_paths
        self.ignored_paths = paths.map { |e| File.absolute_path(e) }
      end
    end

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
      attr_reader :ignored_paths
      attr_reader :full_path

      def initialize(filename, ignored_paths)
        @filename = filename
        @full_path = File.absolute_path(filename)
        @ignored_paths = ignored_paths
      end

      def file?
        File.file?(filename)
      end

      def ignore?
        !ignored_paths.find { |e| full_path.start_with?(e) }.nil?
      end

      def grep
        File.readlines(filename)
          .map.with_index { |l, n| Line.new(filename, l, n + 1) }
          .select { |e| TRAILING_WHITESPACE_PATTERN.match(e.line) }
      end
    end

    private_constant :TRAILING_WHITESPACE_PATTERN
    private_constant :Line
    private_constant :ValidatingFile

    def self.validate(path, config)
      validator = new(path, config)
      validator.print_diagnostics(validator.validate)
    end

    attr_reader :path
    attr_reader :config

    def initialize(path, config)
      @path = path
      @config = config
    end

    def validate
      path = File.join(self.path, '**/*')
      Dir.glob(path)
        .map { |e| ValidatingFile.new(e, config.ignored_paths) }
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
