module KeywordFinder
  class Keywords < Array
    def ordered_by_length
      self.sort{|a,b| b.length <=> a.length }
    end
    def escape_regex_chars string
      Regexp.escape(string).downcase
    end

    def to_regex(options={})
      options = {entire_words_only: true}.merge(options)
      spacer = options[:entire_words_only] ? "\\s" : ""
      @to_regex = {} unless defined?(@to_regex)
      @to_regex[options[:entire_words_only]] ||= Regexp.new("(#{
        self.ordered_by_length.collect do |a|
          a_spacer = spacer
          a_spacer = "" if (options[:entire_words_only] == :when_short and a.length > 3)
          "#{a_spacer}#{self.escape_regex_chars(a.gsub(' ', '  '))}#{a_spacer}"
        end.join("|")
      })")
    end

    def scan_in sentence, options={}
      " #{sentence} ".scan(self.to_regex(options))
    end

    def clean_sentence sentence
      sentence.gsub(/(\.|\?|\,|\;)/," $1 ").gsub(/\n|\s/, '  ').gsub(/[[:space:]]/,' ')
    end

    def combine_more_specifics sentence
      sentence.
        gsub(/([A-Za-z]*\([A-Za-z]*\)[A-Za-z]+)/) { |s| s.gsub(/(\(|\))/,'') }.
        gsub(/([A-Za-z]+\([A-Za-z]*\)[A-Za-z]*)/) { |s| s.gsub(/(\(|\))/,'') }
    end

    def scan_part sentence, options={}
      scan_results = self.scan_in(self.clean_sentence(sentence), options)
      scan_results.flatten!
      scan_results.uniq!
      scan_results.compact!
      results = []
      scan_results.each do |result|
        results << result.strip unless result.strip.empty?
      end
      results.collect{|a| a.gsub('  ', ' ')}
    end

    # find in a sentence
    #
    #
    # @param [String] sentence that might contain the keywords this instance was initalized with
    # @param [Hash] options; notably the +:subsentences_strategy+, which can be one of +:none+, +:ignore_if_found_in_main+, +:always_ignore+ and the +:entire_words_only+ boolean, which can be either +true+, +false+, or :when_short

    def find_in sentence, options={}
      options = {
        subsentences_strategy: :none, # :none, :ignore_if_found_in_main, :always_ignore
        entire_words_only: true
      }.merge(options)

      sentence = sentence.downcase.gsub(/\n/," ")

      full_sentence_results = self.scan_part(sentence, options)

      sentence = self.combine_more_specifics(sentence)
      main_and_subs = self.separate_main_and_sub_sentences(sentence)
      main_results = self.scan_part(main_and_subs[:main], options)

      sub_results = []
      unless (
        options[:subsentences_strategy] == :always_ignore or
        (main_results.count > 0 and options[:subsentences_strategy] == :ignore_if_found_in_main)
        )
        sub_results = main_and_subs[:subs].collect{|subsentence| self.scan_part(subsentence, options)}.flatten
      end

      clean_sentence_results = main_results + sub_results

      return select_the_best_results(clean_sentence_results, full_sentence_results)
    end

    def select_the_best_results result_set_a, result_set_b
      ## check whether there are better matches in the full sentence approach (or the other way around)
      result_set_a_to_delete = []
      result_set_b_to_delete = []

      result_set_a.each do |result_a|
        result_set_b.each do |result_b|
          if result_a.match(escape_regex_chars(result_b))
            result_set_b_to_delete << result_b
          elsif result_b.match(escape_regex_chars(result_a))
            result_set_a_to_delete << result_a
          end
        end
      end

      result_set_a_to_delete.each do |a|
        result_set_a.delete(a)
      end
      result_set_b_to_delete.each do |a|
        result_set_b.delete(a)
      end

      return result_set_a + result_set_b
    end

    def separate_main_and_sub_sentences sentence
      subs = sentence.scan(/(\(.*\))/).flatten
      subs.each do |subsentence|
        sentence = sentence.gsub(subsentence,"")
      end
      {main:sentence.strip,subs:subs.collect{|a| a[1..(a.length-2)].strip}}
    end

  end
end
