# frozen_string_literal: true

module Markets
  class Exchange < ApplicationRecord
    self.primary_key = :market_identification_code

    belongs_to :operating_exchange, # rubocop:disable Rails/InverseOf
               class_name: 'Markets::Exchange',
               primary_key: :market_identification_code,
               foreign_key: :operating_market_identification_code,
               optional: true

    scope :active, -> { where(status: 'ACTIVE') }

    validates :name, length: { minimum: 2 }
    validates :market_identification_code, uniqueness: true
    validates :country, length: { is: 2 }
    validates :legal_entity_name, length: { minimum: 1 }, allow_nil: true

    def self.iterated_search(pattern) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      return [disambiguate(pattern.upcase)] if disambiguate(pattern.upcase).present?

      return search(pattern) unless search(pattern).empty?
      return search("#{pattern}%") unless search("#{pattern}%").empty?
      return search("%#{pattern}%") unless search("#{pattern}%").empty?

      pieces = pattern.split
      (0...pieces.length).each do |piece_count| # rubocop:disable Lint/UnreachableLoop
        iterated_pattern = pieces[0..piece_count].join(' ')
        collection = search("%#{iterated_pattern}%")
        break collection unless collection.active.empty?

        raise ActiveRecord::RecordNotFound
      end
    end

    def self.disambiguate(pattern) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      return find('XMIL') if /BORSA ITALIANA/ =~ pattern
      return find('XCBO') if /CBOE/ =~ pattern
      return find('XAMS') if /EURONEXT AMSTERDAM/ =~ pattern
      return find('XBRU') if /EURONEXT BRUSSELS/ =~ pattern
      return find('XLIS') if /EURONEXT LISBON/ =~ pattern
      return find('XPAR') if /EURONEXT PARIS/ =~ pattern
      return find('ROCO') if /GRETAI SECURITIES MARKET/ =~ pattern || /TAIPEI EXCHANGE/ =~ pattern
      return find('XHEL') if /HELSINKI/ =~ pattern
      return find('ICUS') if /ICE FUTURES U.S./ =~ pattern
      return find('XIST') if /ISTANBUL/ =~ pattern
      return find('XLON') if /LONDON/ =~ pattern
      return find('XNYS') if /NEW YORK STOCK EXCHANGE INC./ =~ pattern
      return find('ARCX') if /NYSE ARCA/ =~ pattern
      return find('XOSE') if /OSAKA/ =~ pattern
      return find('XOSL') if /OSLO/ =~ pattern
      return find('XPHS') if /PHILIPPINE/ =~ pattern
      return find('XPRA') if /PRAGUE/ =~ pattern
      return find('XSHG') if /SHANGHAI/ =~ pattern
      return find('XSHE') if /SHENZHEN/ =~ pattern
      return find('XSES') if /SINGAPORE/ =~ pattern
      return find('XSWX') if /SIX SWISS/ =~ pattern
      return find('MISX') if /STANDARD-CLASSICA-FORTS/ =~ pattern
      return find('XBKK') if /THAILAND/ =~ pattern
      return find('XTKS') if /TOKYO/ =~ pattern
      return find('XTSE') if /TORONTO/ =~ pattern
      return find('XWBO') if /WIENER BOERSE/ =~ pattern
      return find('XBSP') if /XBSP/ =~ pattern || /SAO PAOLO/ =~ pattern
      return find('XETR') if /XETRA/ =~ pattern
      return find('XOME') if %r{OMX NORDIC EXCHANGE COPENHAGEN A/S} =~ pattern || /NASDAQ OMX NORDIC/ =~ pattern

      find('XNAS') if /NASDAQ/ =~ pattern
    end

    def self.search(pattern)
      if pattern.blank?
        active
      else
        active.where('name LIKE ?', pattern.upcase).or(where('legal_entity_name LIKE ?', pattern.upcase))
      end
    end
  end
end
