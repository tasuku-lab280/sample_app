require 'csv'

CSV.generate(encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|
  column_names = %w(name body price)
  csv << column_names
  @csv_data.each do |item|
    column_values = [
      item.name,
      item.body,
      item.price
    ]
    csv << column_values
  end
end
