require 'optparse'
require 'optparse/time'
require 'zlib'

module HarmonizedTariff

  class CLI

    @@type = 'json'
    @@verbose = false
    @@destination = 'data/'

    def self.parse(args)

      hts = HarmonizedTariff::Convert.new

      opt_parser = OptionParser.new do |opts|

        opts.banner = "Usage: bundle exec bin/hts [options]"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-s", "--source [PATH]", "Set source file") do |source|
          hts.source = source || hts.source
        end

        opts.on("-o", "--output [PATH]", "Set destination folder path") do |path|
          @@destination = path || destination
        end

        opts.on("--type [TYPE]", "Select output format (json, xml, sql, gz (gzipped sql))") do |t|
          @@type = t.downcase
        end

        opts.on("-v", "--verbose", "Print output to screen") do |d|
          @@verbose = d
        end

        opts.separator ""
        opts.separator "Common options:"

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("--version", "Show version") do
          puts HarmonizedTariff::VERSION
          exit
        end

      end

      opt_parser.parse!(args)

      # parse the file
      hts.load

      if @@type == 'json'
        self.output hts.toJSON
      elsif @@type == 'xml'
        self.output hts.toXML
      elsif @@type == 'sql'
        self.output hts.toSQL
      elsif @@type == 'gz'
        self.gzip hts.toSQL
      end

    end

    def self.output(data)

      path = File.absolute_path(@@destination) + File::SEPARATOR + 'hts.' + @@type

      puts 'Outputting converted ' + @@type.upcase + ' to: ' + path + "\n"

      target = File.new(path, 'w')
      target.write data
      target.close

      if @@verbose
        puts data
      end

    end

    def self.gzip(data)

      path = File.absolute_path(@@destination) + File::SEPARATOR + 'hts.' + @@type

      puts 'Outputting converted gzipped SQL to: ' + path + "\n"

      File.open(path, 'w') do |f|
        gz = Zlib::GzipWriter.new(f)
        gz.write data
        gz.close
      end

    end

  end

end

