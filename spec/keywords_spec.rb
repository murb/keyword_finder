require 'spec_helper'

describe KeywordFinder::Keywords do
  it 'behaves like an array hence' do
    a = KeywordFinder::Keywords.new(["a","b"])
    expect(a[0]).to eq("a");
    expect(a.last).to eq("b");
    a << "c"
    a << "d"
    expect(a[2]).to eq("c");
    expect(a.last).to eq("d");
    expect(a.class).to eq(KeywordFinder::Keywords);
  end
  describe "#to_regex" do
    it "should return an empty regex if no keywords are present" do
      a = KeywordFinder::Keywords.new()
      expect(a.to_regex).to eq(/()/)
    end
    it "should return a filled regex when keywords are present" do
      a = KeywordFinder::Keywords.new(["a","b"])
      expect(a.to_regex).to eq(/(\sa\s|\sb\s)/)

    end
  end
  describe "#find_in" do
    it 'is implemented and returns [] when empty' do
      a = KeywordFinder::Keywords.new()
      expect(a.find_in("")).to eq([])
    end
    it 'accepts options' do
      a = KeywordFinder::Keywords.new()
      expect(a.find_in("", {})).to eq([])
    end
    it 'finds keywords in sentence' do
      a = KeywordFinder::Keywords.new(["a","b"])
      expect(a.find_in("another ape b")).to eq(["b"])
      expect(a.find_in("another a pe b")).to eq(["a","b"])
    end
    it 'finds keywords in more trashy sentence' do
      a = KeywordFinder::Keywords.new(["a","b"])
      expect(a.find_in("another ape. b?")).to eq(["b"])
      expect(a.find_in("another a. pe b?")).to eq(["a","b"])
    end
    it 'finds keywords in sentence with subsentences' do
      a = KeywordFinder::Keywords.new(["a","b"])
      expect(a.find_in("a (lees b)")).to eq(["a","b"])
    end
    it 'finds keywords in sentence with subsentences {options: strategy: none}' do
      a = KeywordFinder::Keywords.new(["a","b"])
      expect(a.find_in("a (lees b)", {subsentences_strategy: :none})).to eq(["a","b"])
    end
    it 'finds keywords in sentence with subsentences {options: strategy: :always_ignore}' do
      a = KeywordFinder::Keywords.new(["a","b"])
      expect(a.find_in("a (alternatief b)", {subsentences_strategy: :always_ignore})).to eq(["a"])
    end
    it 'finds keywords in sentence with subsentences {options: strategy: :ignore_if_found_in_main}' do
      a = KeywordFinder::Keywords.new(["a","b"])
      expect(a.find_in("a (alternatief b)", {subsentences_strategy: :ignore_if_found_in_main})).to eq(["a"])
      a = KeywordFinder::Keywords.new(["ab","b"])
      expect(a.find_in("a (alternatief b)", {subsentences_strategy: :ignore_if_found_in_main})).to eq(["b"])
    end
  end
  describe "#separate_main_and_sub_sentences" do
    it "should return empty string when empty string is given" do
      a = KeywordFinder::Keywords.new(["a","b"])
      expect(a.separate_main_and_sub_sentences("")).to eq({main:"",subs:[]})
    end
    it "should return sentence between brackets" do
      a = KeywordFinder::Keywords.new(["a","b"])
      expect(a.separate_main_and_sub_sentences("hallo (is dit wel een) zin")).to eq({main:"hallo  zin",subs:["is dit wel een"]})
    end
  end

  describe "#complex_test" do
    it "should work for these examples" do
      a = KeywordFinder::Keywords.new(["aardappelen", "zachtkokende aardappelen", "zout",
        "schimmelkaas", "kaas", "oude harde kaas", "kikkererwten", "maïs",
        "bruine bonen", "shiitake", "boter"])

      examples = {"een grote pan zachtkokende aardappelen met een snufje zout"=>["zachtkokende aardappelen", "zout"],
        "schimmelkaas" => ["schimmelkaas"],
        "(schimmel)kaas" => ["schimmelkaas"],
        "old amsterdam (maar een andere oude harde kaas kan natuurlijk ook)" => ["oude harde kaas"],
        "g (verse) shiitake in bitesize stukjes gesneden" => ["shiitake"],
        "pot hak bonenmix (kikkererwten maïs kidney en bruine bonen) afgespoeld en uitgelekt" => ["kikkerwerwten", "maïs", "bruine bonen"],
        "g boter gesmolten en licht afgekoeld" => ["boter"]}

      examples.each do |sentence, expected|
        expect(a.find_in(sentence).to eq(expected))
      end
    end
  end

end
