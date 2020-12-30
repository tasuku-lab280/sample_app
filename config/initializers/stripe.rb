Rails.configuration.stripe = {
  public_key: STRIPE_TEST_PUBLIC_KEY,
  secret_key: STRIPE_TEST_SECRET_KEY,
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
