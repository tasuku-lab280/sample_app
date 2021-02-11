設計 Stripe
===========

## 顧客登録

`Stripe::Customer.create`



### パラメータ

| 物理名 | 必須 | 備考       |
|-------|-----|------------|
| email | 任意 | 検索の効率化 |



### サンプル

```ruby
customer = Stripe::Customer.create({
  email: current_user.email,
})
current_user.update!(stripe_customer_id: customer.id)
```



## 顧客削除

  `Stripe::Customer.delete`



### パラメータ

| 物理名 | 必須 | 備考           |
|-------|-----|----------------|
| id    | 必須 | stripeの顧客ID |



### サンプル

```ruby
Stripe::Customer.delete({
  id: current_user.stripe_customer_id
})
```



## クレカ登録

  `Stripe::Customer.create_source`



### パラメータ



### サンプル

```ruby
Stripe::Customer.create_source({
  id: current_user.stripe_customer_id,
  source: card_token,
})
```


## クレカ削除

  `Stripe::Customer.delete_source`


## 一回課金

  `Stripe::Charge.create`




## フロントエンド

checkout.jsを使用

> https://stripe.com/docs/payments/checkout


## バックエンド


以上
