module Whitespace
  class Base
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
        self.ignored_paths = paths.map { |e| ::File.absolute_path(e) }
      end
    end

    class File
      attr_reader :filename
      attr_reader :ignored_paths
      attr_reader :full_path

      def initialize(filename, ignored_paths)
        @filename = filename
        @full_path = ::File.absolute_path(filename)
        @ignored_paths = ignored_paths
      end

      def file?
        ::File.file?(filename)
      end

      def ignore?
        !ignored_paths.find { |e| full_path.start_with?(e) }.nil?
      end
    end

    def self.invoke(path, config)
      new(path, config).invoke
    end

    attr_reader :path
    attr_reader :config

    def initialize(path, config)
      @path = path
      @config = config
    end

    def invoke
      raise NotImplementedError, 'Missing implementation for abstract method ' \
        "'invoke'"
    end
  end
end
