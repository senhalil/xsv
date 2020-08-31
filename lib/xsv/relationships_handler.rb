# frozen_string_literal: true
module Xsv
  # RelationshipsHandler parses the "xl/_rels/workbook.xml.rels" file to get the existing relationships.
  # This is used internally  when opening a workbook.
  class RelationshipsHandler < Nokogiri::XML::SAX::Document
    def self.get_relations(io)
      relations = []
      handler = new do |relation|
        relations << relation
      end

      Nokogiri::XML::SAX::Parser.new(handler).parse(io)
      return relations
    end

    def initialize(&block)
      @block = block
    end

    def start_element(name, attrs)
      @block.call(attrs.map { |k, v| [k.to_sym, v] }.to_h.slice(*%i{Id Type Target})) if name == "Relationship"
    end
  end
end
