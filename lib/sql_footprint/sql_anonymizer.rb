module SqlFootprint
  class SqlAnonymizer
    GSUBS = {
      /\sIN\s\((.*)\)/ => ' IN (values-redacted)'.freeze, # IN clauses
      /\s\=\s([0-9]+)/ => ' = number-redacted'.freeze, # numbers
      /\s'(.*)\'/ => " 'value-redacted'".freeze, # literal strings
    }
    ['>', '<', '!=', '<=', '>='].each do |operator|
      GSUBS[/\s#{Regexp.quote(operator)}\s([0-9]+)/] = " #{operator} number-redacted"
    end
    GSUBS.freeze

    def anonymize sql
      GSUBS.reduce(sql) do |s, (regex, replacement)|
        s.gsub regex, replacement
      end
    end
  end
end
