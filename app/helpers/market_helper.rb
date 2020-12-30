module MarketHelper
  def root_categories
    @root_categories ||= Category.level(1).order_tree
  end
end
