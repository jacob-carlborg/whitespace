module Whitespace
  class Stripper
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

      def strip
        lines = File.readlines(filename)
        write_file = false

        lines.map do |line|
          if TRAILING_WHITESPACE_PATTERN.match(line)
            write_file = true
            line.gsub!(TRAILING_WHITESPACE_PATTERN, '')
          end

          line
        end

        File.write(filename, lines.join('')) if write_file
      end
    end

    def self.strip(path, config)
      new(path, config).strip
    end

    attr_reader :path
    attr_reader :config

    def initialize(path, config)
      @path = path
      @config = config
    end

    def strip
      path = File.join(self.path, '**/*')
      Dir.glob(path)
        .map { |e| ValidatingFile.new(e, config.ignored_paths) }
        .select(&:file?)
        .reject(&:ignore?)
        .each(&:strip)
    end
  end
end
