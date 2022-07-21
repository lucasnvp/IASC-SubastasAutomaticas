# IASC-SubastasAutomaticas
Implementacion de  Arquitecturas de Software Concurrentes

[Enunciado](https://docs.google.com/document/d/1rOg2TUugXZgx23GhXBzUHakV3vDEkfaT2HLzVKIZ1Q0/edit)

## How to test it with CURL
### Buyers
` curl -d 'name=usertest&ip=10.0.0.1&tags=[decoracion, iluminacion]' -X POST http://localhost:4000/api/buyers `

` curl -d 'id=1&price=10' -X POST http://localhost:4000/api/buyers_bid `

` curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:4000/api/buyers/get `

### Bids
` curl -d 'tags=[decoracion, iluminacion]&defaultPrice=10&duration=100&item=lampara' -X POST http://localhost:4000/api/bids `

## How to test it in IEX

`conn = Phoenix.ConnTest.build_conn()`

`SubastasAppWeb.BuyerController.create(conn, %{"name" => "usertestA", "ip" => "10.0.0.1", "tags" => "[decoracion, iluminacion]"})`

`SubastasAppWeb.BuyerController.create(conn, %{"name" => "usertestB", "ip" => "10.0.0.1", "tags" => "[bazar, comida]"})`

`SubastasAppWeb.BuyerController.get_buyers(conn, %{})`

`SubastasAppWeb.BidController.create(conn, %{"tags" => "[casa, iluminacion]", "defaultPrice" => "10", "duration" => "100", "item" => "lampara"})`

`SubastasAppWeb.BuyerController.bid(conn, %{"userId" => 1, "bidId" => 1, "price" => "20"})`
