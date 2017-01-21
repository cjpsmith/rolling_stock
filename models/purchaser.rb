class Purchaser
  attr_reader :companies
  attr_accessor :cash, :pending_cash

  def initialize cash
    @cash = cash
    @pending_cash = 0
    @companies = []
  end

  def pp_cash
    str = String.new "$#{@cash}"
    str << " ($#{@pending_cash})" if @pending_cash > 0
    str
  end

  def buy_company company, price
    owner = company.owner
    raise GameException, "Can't buy own company" if owner == self
    raise GameException, "You don't have enough money to buy at that price" if @cash < price
    raise GameException, "Company can't be sold. Last company or just sold" unless company.can_be_sold?

    @cash -= price
    owner.pending_cash += price if owner.respond_to? :pending_cash
    owner.companies.delete company

    company.recently_sold = true
    company.owner = self
    @companies << company
    @log << "#{name} buys #{company.name} for $#{price} from #{owner&.name}"
  end

  def close_company company
    raise GameException, "#{name} does not own #{company.name}" unless @companies.include? company

    if company.owner.is_a?(Corporation) && company.owner.companies.size == 1
      raise GameException, "Can't close last company"
    end

    @companies.delete company
    @log << "#{name} closes #{company.name}"
  end

  def collect_income tier
    amount = income(tier)
    @cash += amount
    @log << "#{name} collects $#{amount} income"
  end

  def income tier
    base_income - cost_of_ownership(tier)
  end

  def base_income
    total = 0
    @companies.each { |c| total += c.income }
    total
  end

  def negative_income? tier
    (@cash + income(tier)) < 0
  end

  def cost_of_ownership tier
    total = 0
    @companies.each { |c| total += c.cost_of_ownership tier }
    total
  end

  def finalize_purchases
    @cash += @pending_cash
    @pending_cash = 0
    @companies.each { |c| c.recently_sold = false }
  end
end
