require "csv"
require "json"
require "active_support/core_ext"
require "heredoc_unindent"

module HarmonizedTariff

  class Convert

    attr_accessor :source, :encoding, :delimeter

    def initialize
      @source = 'data/1300_HTS_delimited.txt'
      @encoding = 'ISO8859-1'
      @delimeter = '|'
      @raw = Array.new
    end

    def toJSON
      return @data.to_json
    end

    def toXML
      return @data.to_xml(:root => 'tariffs')
    end

    def toSQL

      sql = <<-SQL.unindent
              -- create the table
              CREATE TABLE `harmonized_tariffs` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `code` varchar(255) NOT NULL DEFAULT '',
                `suffix` varchar(255) DEFAULT NULL,
                `description` text,
                `unit` varchar(255) DEFAULT NULL,
                `rate_1` varchar(255) DEFAULT NULL,
                `special_rate` varchar(255) DEFAULT '',
                `rate_2` varchar(255) DEFAULT NULL,
                `notes` text,
                PRIMARY KEY (`id`),
                KEY `tariff` (`code`)
              ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
              -- insert the flattened data
            SQL

      @data.each do |child|
        sql << self.buildSQL(child)
      end

      return sql

    end

    def buildSQL(parent)

      sql = ''

      unless parent[:number].nil?
        sql << self.sqlRow(parent)
      end

      if parent[:children].nil?
        return sql
      end

      parent[:children].each do |child|

        child[:description] = parent[:description] + ' ' + child[:description]

        sql << self.buildSQL(child)

      end

      return sql

    end

    def sqlRow(row)

      clean = Hash.new

      row.each do |k,v|

        if k == :children
          next
        end

        if v.nil?
          clean[k] = 'NULL'
        else
          clean[k] = "'" + self.escape(v) + "'"
        end

      end

      sql = <<-SQL.unindent
              INSERT INTO `harmonized_tariffs` (`id`, `code`, `suffix`, `description`, `unit`, `rate_1`, `special_rate`, `rate_2`, `notes`)
              VALUES (NULL, #{clean[:number]}, #{clean[:suffix]}, #{clean[:description]}, #{clean[:unit]}, #{clean[:col1_rate]}, #{clean[:special_rate]}, #{clean[:col2_rate]}, #{clean[:note]});
            SQL


      return sql

    end

    def escape(text)

      text = text.gsub(/'/) {|s| "\\'"}
      text = text.gsub(/"/) {|s| "\""}
      text = text.gsub(/\\/) {|s| "\\"}

      return text

    end

    def load

      parent = nil
      previous = nil

      @raw = CSV.read(@source, col_sep: @delimeter, encoding: @encoding, quote_char: "\x00")

      root = self.build_heirarchy(Hash.new, 0, 1)

      @data = root[:children]

      @raw = nil
      root = nil

    end

    def build_heirarchy(parent, depth, index)

      siblings = Array.new

      while index < @raw.length

        current = Hash.new

        current[:number], current[:suffix], level, current[:description], current[:unit], current[:col1_rate], current[:special_rate], current[:col2_rate], current[:note] = @raw[index]

        if level.nil?
          index += 1
          next
        end

        if level.to_i == depth
          index += 1
          siblings.push self.build_heirarchy(current, depth + 1, index)
          next
        end

        if level.to_i < depth

          if siblings.length > 0
            parent[:children] = siblings
          end

          return parent

        end

        index += 1

      end

      if siblings.length > 0
        parent[:children] = siblings
      end

      return parent

    end

  end

end

