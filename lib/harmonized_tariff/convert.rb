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
              CREATE TABLE `harmonized_tariffs` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `code` varchar(255) NOT NULL DEFAULT '',
                `description` text,
                `unit` varchar(255) DEFAULT NULL,
                `rate_1` varchar(255) DEFAULT NULL,
                `special_rate` varchar(255) DEFAULT '',
                `rate_2` varchar(255) DEFAULT NULL,
                `notes` text,
                PRIMARY KEY (`id`),
                KEY `tariff` (`code`)
              ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
            SQL

      # TODO: Shit out flat SQL

    end

    def load

      parent = nil
      previous = nil

      @raw = CSV.read(@source, col_sep: @delimeter, encoding: @encoding, quote_char: "\x00")

      root = self.build_heirarchy(Hash.new, 0, 0)

      @data = root[:children]

    end

    def build_heirarchy(parent, depth, index)

      siblings = Array.new

      while index < @raw.length

        current = Hash.new

        current[:number], current[:suffix], level, current[:description], current[:unit], current[:col1_rate], current[:special_rate], current[:col2_rate], current[:note] = @raw[index]

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

