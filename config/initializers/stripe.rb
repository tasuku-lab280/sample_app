# 開発環境とテスト環境にはstripeのテストモードのAPIキーを使用する
if Rails.env.development? || Rails.env.test?
  Rails.configuration.stripe = {
    :public_key => ENV['STRIPE_TEST_PUBLIC_KEY'],
    :secret_key => ENV['STRIPE_TEST_SECRET_KEY'],
  }
end

# 本番環境にはstripeの本番環境用APIキーを使用する
if Rails.env.production?
  return
end

# それぞれの環境に適したstripeAPIキーをセットしておく。
Stripe.api_key = Rails.configuration.stripe[:secret_key]
