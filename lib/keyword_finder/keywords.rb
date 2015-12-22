module KeywordFinder
  class Keywords < Array
    def to_regex
      @to_regex ||= Regexp.new("(#{self.collect{|a| "\\s#{a}\\s"}.join("|")})")
    end

    def scan_in sentence
      " #{sentence} ".scan(self.to_regex)
    end

    def clean_sentence sentence
      sentence.gsub(/(\.|\?|\,|\;)/," $1 ")
    end

    def combine_more_specifics sentence
      sentence.gsub(/([A-Za-z]*\([A-Za-z]*\)[A-Za-z]*)/) { |s| s.gsub(/(\(|\))/,'') }
    end

    def scan_part sentence
      scan_results = self.scan_in(self.clean_sentence(sentence))
      scan_results.flatten!
      scan_results.uniq!
      results = []
      scan_results.each do |result|
        results << result.strip unless result.strip.empty?
      end
      results
    end

    def find_in sentence, options={}
      options = {
        subsentences_strategy: :none # :none, :ignore_if_found_in_main, :always_ignore
      }.merge(options)

      sentence = self.combine_more_specifics(sentence)
      main_and_subs = self.separate_main_and_sub_sentences(sentence)
      main_results = self.scan_part(main_and_subs[:main])
      sub_results = []
      unless (
        options[:subsentences_strategy] == :always_ignore or
        (main_results.count > 0 and options[:subsentences_strategy] == :ignore_if_found_in_main)
        )
        sub_results = main_and_subs[:subs].collect{|subsentence| self.scan_part(subsentence)}.flatten
      end
      return main_results + sub_results
    end

    def separate_main_and_sub_sentences sentence
      subs = sentence.scan(/(\(.*\))/).flatten
      subs.each do |subsentence|
        sentence = sentence.gsub(subsentence,"")
      end
      {main:sentence,subs:subs.collect{|a| a[1..(a.length-2)]}}
    end

  end
end
