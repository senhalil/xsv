# frozen_string_literal: true
module Xsv
  # SheetsIdsHandler interprets the relevant parts of workbook.xml
  # This is used internally to get the sheets ids, relationship_ids, and names when opening a workbook.
  class SheetsIdsHandler < Nokogiri::XML::SAX::Document
    def self.get_sheets_ids(io)
      sheets_ids = []
      handler = new do |sheet_ids|
        sheets_ids << sheet_ids
      end

      Nokogiri::XML::SAX::Parser.new(handler).parse(io)

      return sheets_ids
    end

    def initialize(&block)
      @block = block
    end

    def start_element(name, attrs)
      @block.call(attrs.map { |k, v| [k.to_sym, v] }.to_h.slice(*%i{name sheetId state r:id})) if name == "sheet"
    end
  end
end
