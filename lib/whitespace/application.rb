module Whitespace
  class Application < Thor
    desc 'validate [PATH]', 'Reports files with trailing whitespace'

    long_desc <<-DESC
      `ws validate [PATH]` will report all files in the given path which contain
      lines with trailing whitespace. Each line with trailing whitespace will be
      reported with: the filname, the line number and the content.
      The trailing whitespace will be highlighted with a background color.

      If the path is omitted it will default to using the current directory.

      If tailing whitespace are reported it will exit with a non-zero exit code.
    DESC

    option :ignored_paths,
           type: :array,
           default: [],
           desc: 'A list paths to ignore'

    def validate(path = '.')
      Validator.validate(path, Validator::Config.new(options))
    end

    desc 'strip [PATH]', 'Strips trailing whitespace in all files in the ' \
      'given path'

    long_desc <<-DESC
      `ws strip [PATH]` will strip trailing whitespace in all files in the given
      path

      If the path is omitted it will default to using the current directory.
    DESC

    option :ignored_paths,
           type: :array,
           default: [],
           desc: 'A list paths to ignore'

    def strip(path = '.')
      Stripper.strip(path, Stripper::Config.new(options))
    end
  end
end
