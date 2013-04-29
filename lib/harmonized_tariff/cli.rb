require 'optparse'
require 'optparse/time'
require 'ostruct'

module HarmonizedTariff

  class CLI

    def self.parse(args)

      output = :json
      dump = false
      destination = 'data/'

      hts = HarmonizedTariff::Convert.new

      opt_parser = OptionParser.new do |opts|

        opts.banner = "Usage: bundle exec bin/hts [options]"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-s", "--source [PATH]", "Set source file") do |source|
          hts.path = source || hts.path
        end

        opts.on("-o", "--output [PATH]", "Set destination path") do |path|
          destination = path || destination
        end

        opts.on("--type [TYPE]", [:json, :xml, :sql], "Select output format (json, xml, sql)") do |t|
          output = t
        end

        opts.on("-v", "--verbose", "Print output to screen") do |d|
          dump = d
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

      if output == :json

        json = hts.toJSON

        target = File.new(destination + 'hts.json', 'w')
        target.write(json)
        target.close

        if dump
          puts json
        end

      elsif output == :xml

        xml = hts.toXML

        target = File.new(destination + 'hts.xml', 'w')
        target.write(xml)
        target.close

        if dump
          puts xml
        end

      elsif output == :sql

        sql = hts.toSQL

        target = File.new(destination + 'hts.sql', 'w')
        target.write(sql)
        target.close

        if dump
          puts sql
        end

      end

    end

  end

end

