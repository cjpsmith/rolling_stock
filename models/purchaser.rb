module Purchaser
  def buy_company company, price
    owner = company.owner
    raise "Can't buy own company" if owner == self
    raise 'Not enough cash' if @cash < price
    raise "Can't sell last company" if owner.is_a?(Corporation) && owner.companies.size == 1

    @cash -= price
    owner.cash += price if owner.respond_to? :cash
    owner.companies.delete company

    company.owner = self
    @companies << company
    @log << "#{name} buys #{company.name} for #{price}"
  end

  def close_company company
    @companies.delete company
    @log << "#{name} closes #{company.name}"
  end

  def collect_income tier
    amount = income(tier)
    @cash += amount
    @log << "#{name} collects #{amount} income"
  end

  def income tier
    @companies
      .map { |c| c.income - c.cost_of_ownership(tier) }
      .reduce(&:+) || 0
  end
end
