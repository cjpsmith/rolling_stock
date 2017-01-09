require './models/passer'
require './models/ownable'

class Company
  include Passer
  include Ownable

  TIERS = [:red, :orange, :yellow, :green, :blue, :purple].freeze

  OWNERSHIP_TIERS = {
    green: [:red],
    blue: [:red, :orange],
    purple: [:red, :orange, :yellow],
    penultimate: [:red, :orange, :yellow, :green],
    last_turn: [:red, :orange, :yellow, :green],
  }.freeze

  OWNERSHIP_COSTS = {
    green: 1,
    blue: 3,
    purple: 6,
    penultimate: 10,
    last_turn: 16,
  }.freeze

  COMPANIES = {
    'BME' => ['Bergisch-Märkische Eisenbahn-Gesellschaft', :red, 1, 1, ['KME', 'BD', 'HE', 'PR']],
    'BSE' => ['Berlin-Stettiner Eisenbahn-Gesellschaft', :red, 2, 1, ['BPM', 'SX', 'MS', 'PR']],
    'KME' => ['Köln-Mindener Eisenbahn-Gesellschaft', :red, 5, 2, ['BME', 'MHE', 'OL', 'HE', 'PR']],
    'AKE' => ['Altona-Kieler Eisenbahn-Gesellschaft', :red, 6, 2, ['BPM', 'MHE', 'OL', 'MS', 'PR']],
    'BPM' => ['Berlin-Potsdam-Magdeburger Eisenbahn', :red, 7, 2, ['BSE', 'AKE', 'MHE', 'SX', 'MS', 'PR']],
    'MHE' => ['Magdeburg-Halberstädter Eisenbahngesellschaft', :red, 8, 2, ['KME', 'AKE', 'BPM', 'OL', 'SX', 'MS', 'PR']],

    'WT' => ['Königlich Württembergische Staats-Eisenbahnen', :orange, 11, 3, ['BD', 'BY', 'SBB', 'DR']],
    'BD' => ['Großherzoglich Badische Staatseisenbahnen', :orange, 12, 3, ['BME', 'WT', 'HE', 'SNCF', 'SBB', 'DR']],
    'BY' => ['Königlich Bayerische Staatseisenbahnen', :orange, 13, 3, ['WT', 'HE', 'SX', 'KK', 'DR']],
    'OL' => ['Großherzoglich Oldenburgische Staatseisenbahnen', :orange, 14, 3, ['KME', 'AKE', 'MHE', 'MS', 'PR', 'DSB', 'NS', 'DR']],
    'HE' => ['Großherzoglich Hessische Staatseisenbahnen', :orange, 15, 3, ['BME', 'KME', 'BD', 'BY', 'PR', 'DR']],
    'SX' => ['Königlich Sächsische Staatseisenbahnen', :orange, 16, 3, ['BSE', 'BPM', 'MHE', 'BY', 'MS', 'PR', 'PKP', 'KK', 'DR']],
    'MS' => ['Großherzoglich Mecklenburgische Friedrich-Franz-Eisenbahn', :orange, 17, 3, ['BSE', 'AKE', 'BPM', 'MHE', 'OL', 'SX', 'PR', 'DSB', 'PKP', 'DR']],
    'PR' => ['Preußische Staatseisenbahnen', :orange, 19, 3, ['BME', 'BSE', 'KME', 'AKE', 'BPM', 'MHE', 'OL', 'HE', 'SX', 'MS', 'DSB', 'NS', 'B', 'PKP', 'DR']],

    'DSB' => ['Danske Statsbaner', :yellow, 20, 6, ['OL', 'MS', 'PR', 'DR', 'BSR', 'HH']],
    'NS' => ['Nederlandse Spoorwegen', :yellow, 21, 6, ['OL', 'PR', 'B', 'DR', 'E', 'HA', 'HR']],
    'B' => ['Nationale Maatschappij der Belgische Spoorwegen – Société ' 'Nationale des Chemins de fer Belges', :yellow, 22, 6, ['PR', 'NS', 'SNCF', 'DR', 'E', 'HA', 'HR']],
    'PKP' => ['Polskie Koleje Państwowe', :yellow, 23, 6, ['SX', 'MS', 'PR', 'KK', 'DR', 'SZD', 'BSR', 'HH', 'FRA']],
    'SNCF' => ['Société nationale des chemins de fer français', :yellow, 24, 6, ['BD', 'B', 'SBB', 'DR', 'RENFE', 'FS', 'E', 'HA', 'CDG']],
    'KK' => ['k.k. Österreichische Staatsbahnen', :yellow, 25, 6, ['BY', 'SX', 'PKP', 'SBB', 'DR', 'FS', 'FRA']],
    'SBB' => ['Schweizerische Bundesbahnen – Chemins de fer fédéraux ' 'suisses – Ferrovie federali svizzere', :yellow, 26, 6, ['WT', 'BD', 'SNCF', 'KK', 'DR', 'FS', 'CDG', 'FRA']],
    'DR' => ['Deutsche Reichsbahn', :yellow, 29, 6, ['WT', 'BD', 'BY', 'OL', 'HE', 'SX', 'MS', 'PR', 'DSB', 'NS', 'B', 'PKP', 'SNCF', 'KK', 'SBB', 'BSR', 'HH', 'HR', 'FRA']],

    'SJ' => ['Statens Järnvägar', :green, 30, 12, ['BSR']],
    'SZD' => ['Советские железные дороги (Sovetskie železnye dorogi)', :green, 31, 12, ['PKP']],
    'RENFE' => ['Red Nacional de los Ferrocarriles Españoles', :green, 32, 12, ['SNCF', 'MAD']],
    'BR' => ['British Rail', :green, 33, 12, ['E', 'LHR']],
    'FS' => ['Ferrovie dello Stato', :green, 37, 10, ['SNCF', 'KK', 'SBB']],
    'BSR' => ['Baltic Sea Rail', :green, 40, 10, ['DSB', 'PKP', 'DR', 'SJ', 'HH']],
    'E' => ['Eurotunnel', :green, 43, 10, ['NS', 'B', 'SNCF', 'BR', 'HA', 'HR', 'LHR', 'CDG']],

    'MAD' => ['Madrid-Barajas Airport', :blue, 45, 15, ['RENFE', 'FR', 'VP', 'LE']],
    'HA' => ['Haven van Antwerpen', :blue, 47, 15, ['NS', 'B', 'SNCF', 'E', 'RU', 'AL']],
    'HH' => ['Hamburger Hafen', :blue, 48, 15, ['DSB', 'PKP', 'DR', 'BSR']],
    'HR' => ['Haven van Rotterdam', :blue, 49, 15, ['NS', 'B', 'DR', 'E', 'RU', 'AL']],
    'LHR' => ['London Heathrow Airport', :blue, 54, 15, ['BR', 'E', 'FR', 'MM', 'VP', 'LE']],
    'CDG' => ['Aéroport Paris-Charles-de-Gaulle', :blue, 56, 15, ['SNCF', 'SBB', 'E', 'FR', 'VP', 'LE']],
    'FRA' => ['Flughafen Frankfurt', :blue, 58, 15, ['PKP', 'KK', 'SBB', 'DR', 'FR', 'MM', 'LE']],
    'FR' => ['Ryanair', :blue, 60, 15, ['MAD', 'LHR', 'CDG', 'FRA']],

    'OPC' => ['Outer Planet Consortium', :purple, 70, 25,  ['RU', 'AL', 'TSI']],
    'RCC' => ['Ring Construction Corporation', :purple, 71, 25, ['RU', 'AL', 'TSI']],
    'MM' => ['Mars Mining Associates', :purple, 75, 25, ['LHR', 'FRA', 'LE', 'TSI']],
    'VP' => ['Venus Prospectors', :purple, 80, 25, ['MAD', 'LHR', 'CDG', 'LE', 'TSI']],
    'RU' => ['Resources Unlimited', :purple, 85, 25, ['HA', 'HH', 'HR', 'OPC', 'RCC', 'TSI']],
    'AL' => ['Asteroid League', :purple, 86, 25, ['HA', 'HH', 'HR', 'OPC', 'RCC', 'TSI']],
    'LE' => ['Lunar Enterprises', :purple, 90, 25, ['MAD', 'LHR', 'CDG', 'FRA', 'MM', 'VP', 'TSI']],
    'TSI' => ['Trans-Space Inc.', :purple, 100, 25, ['OPC', 'RCC', 'MM', 'VP', 'AL', 'LE' ]],
  }.freeze

  attr_reader :name, :full_name, :tier, :value, :income, :synergies
  attr_accessor :owner, :recently_sold

  def self.all
    @@all ||= Company::COMPANIES.map do |sym, params|
      [sym, Company.new(self, sym, *params).freeze]
    end.to_h.freeze
  end

  def self.valid_share_price_for_tier? share_price, tier
    range =
      case tier
      when :red
        [10, 14]
      when :orange
        [10, 20]
      when :yellow
        [10, 26]
      when :green
        [15, 34]
      when :blue
        [22, 45]
      when :purple
        [28, 45]
      else
        raise GameException, "Invalid tier #{tier} - for share price $#{share_price.price}"
      end

    share_price.price.between? range[0], range[1]
  end

  def self.color_for_tier tier
    case tier
    when :red
      'indianred'
    when :orange
      'orange'
    when :yellow
      ' #FFFF33'
    when :green
      'lightgreen'
    when :blue
      'lightblue'
    when :purple
      'mediumpurple'
    end
  end

  def initialize owner, name, full_name, tier, value, income, synergies, log = nil
    @name      = name
    @full_name = full_name
    @tier      = tier
    @value     = value
    @income    = income
    @synergies = synergies
    @owner     = owner
    @cash      = 0
    @log       = log || []
  end

  def id
    @name
  end

  def synergy_income companies
    keys = companies.keys.sort!

    if @cached_keys != keys
      @cached_keys = keys
      @total = 0
      @synergies.each do |synergy|
        sc = companies[synergy]
        @total += synergy_by_tier sc.tier if sc && sc.value < @value
      end
    end
    @total
  end

  def synergy_by_tier other_tier
    return 0 unless other_tier

    case @tier
    when :red
      1
    when :orange
      other_tier == :red ? 1 : 2
    when :yellow
      other_tier == :orange ? 2 : 4
    when :green
      4
    when :blue
      [:green, :yellow].include?(other_tier) ? 4 : 8
    when :purple
      other_tier == :blue ? 8 : 16
    end
  end

  def pending_closure? phase, ownership_tier
    phase == 7 &&
      owner.is_a?(Corporation) &&
      owner.negative_income?(ownership_tier) &&
      owner.companies.size > 1
  end

  def auto_close? phase, ownership_tier
    phase == 7 &&
      owner.is_a?(Corporation) &&
      owner.negative_income?(ownership_tier) &&
      owner.companies.size == 1
  end

  def can_be_sold?
    !(owner.is_a?(Corporation) && owner.companies.size == 1) && !recently_sold
  end

  def valid_share_price? share_price
    self.class.valid_share_price_for_tier? share_price, @tier
  end

  def valid_price? price
    price.between? min_price, max_price
  end

  def cost_of_ownership for_tier
    if OWNERSHIP_TIERS[for_tier]&.include? @tier
      OWNERSHIP_COSTS[for_tier]
    else
      0
    end
  end

  def min_price
    (@value + 1) / 2
  end

  def max_price
    case @tier
    when :red
      @income + @value
    when :orange
      @value * 1.22 + 1
    when :yellow
      @value * 1.20 + 2
    when :green
      @value * 1.19 + 7
    when :blue
      @value * 1.14 + 16
    when :purple
      @value * 1.10 + 30
    end.floor
  end

  def color
    self.class.color_for_tier @tier
  end
end
