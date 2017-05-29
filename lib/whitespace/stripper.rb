module Whitespace
  class Stripper < Base
    class File < Base::File
      def strip
        lines = ::File.readlines(filename, encoding: Encoding::BINARY)
        write_file = false

        lines.map do |line|
          if Base::TRAILING_WHITESPACE_PATTERN.match(line)
            write_file = true
            line.gsub!(Base::TRAILING_WHITESPACE_PATTERN, '')
          end

          line
        end

        ::File.write(filename, lines.join('')) if write_file
      end
    end

    def invoke
      path = ::File.join(self.path, '**/*')
      Dir.glob(path)
        .map { |e| File.new(e, config.ignored_paths) }
        .select(&:file?)
        .reject(&:ignore?)
        .each(&:strip)
    end
  end
end
