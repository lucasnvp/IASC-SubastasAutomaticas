# IASC-SubastasAutomaticas
Implementacion de  Arquitecturas de Software Concurrentes

[Enunciado](https://docs.google.com/document/d/1rOg2TUugXZgx23GhXBzUHakV3vDEkfaT2HLzVKIZ1Q0/edit)

## How to test it with CURL
### Buyers
` curl -d 'name=usertest&ip=10.0.0.1&tags=[decoracion, iluminacion]' -X POST http://localhost:4000/api/buyers `

` curl -d 'id=1&price=10' -X POST http://localhost:4000/api/buyers_bid `

` curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:4000/api/buyers/get `

### Bids
` curl -d 'tags=[decoracion, iluminacion]&defaultPrice=10&duration=100000&item=lampara' -X POST http://localhost:4000/api/bids `

### Offer

` curl -d 'userId=0e4dbc5f-1f90-477f-9e8d-b2d0ec7cc836&bidId=9cf8dfcc-dac3-4c08-9d6b-de1d8bd98c45&price' -X POST http://localhost:4000/api/buyers/offer `

## How to test it in IEX

`conn = Phoenix.ConnTest.build_conn()`

`SubastasAppWeb.BuyerController.create(conn, %{"name" => "usertestA", "ip" => "10.0.0.1", "tags" => ["decoracion", "iluminacion"]})`

`SubastasAppWeb.BuyerController.create(conn, %{"name" => "usertestB", "ip" => "10.0.0.1", "tags" => ["bazar", "comida"]})`

`SubastasAppWeb.BuyerController.create(conn, %{"name" => "usertestC", "ip" => "10.0.0.1", "tags" => ["decoracion", "iluminacion"]})`

`SubastasAppWeb.BuyerController.get_buyers(conn, %{})`

`SubastasAppWeb.BidController.create(conn, %{"tags" => ["casa", "iluminacion"], "defaultPrice" => "10", "duration" => "100", "item" => "lampara"})`

`SubastasAppWeb.BuyerController.offer(conn, %{"userId" => "bfcdcf5b-f7ff-4aed-bf75-11a3c7d36974", "bidId" => "9c4e751c-7b2d-44e4-afa3-05c26fb674df", "price" => "20"})`

# Get bid id for offers post
`alias SubastasAppWeb.BuyerModel`
`Memento.transaction! fn -> Memento.Query.all(BuyerModel) end`
`alias SubastasAppWeb.BidModel`
`Memento.transaction! fn -> Memento.Query.all(BidModel) end`

