# HarmonizedTariff

A utility for converting the Harmonized Tariff Schedule from [hts.usitc.gov](http://www.usitc.gov/tata/hts/_1300_delimited.htm) to JSON, SQL, and XML.

## Installation

Add this line to your application's Gemfile:

    gem 'harmonized_tariff'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install harmonized_tariff

## Usage

    $ bundle exec bin/hts --help
    Usage: bundle exec bin/hts [options]

    Specific options:
        -s, --source [PATH]              Set source file
        -o, --output [PATH]              Set destination folder path
            --type [TYPE]                Select output format (json, xml, sql, gz (gzipped sql))
        -v, --verbose                    Print output to screen

    Common options:
        -h, --help                       Show this message
            --version                    Show version

**Example 1:** use the provided source file (2013) and output it as gzipped SQL to the Desktop

    $ bundle exec bin/hts --output ~/Desktop --type gz
    Outputting converted gzipped SQL to: /Users/todd/Desktop/hts.gz

**Example 2:** use a different source file (2012) and output it as XML to the Desktop

    $ bundle exec bin/hts --source ~/Desktop/1201_HTS_delimited.txt --output ~/Desktop --type xml
    Outputting converted XML to: /Users/todd/Desktop/hts.xml

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
