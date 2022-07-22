# IASC-SubastasAutomaticas
Implementacion de  Arquitecturas de Software Concurrentes

[Enunciado](https://docs.google.com/document/d/1rOg2TUugXZgx23GhXBzUHakV3vDEkfaT2HLzVKIZ1Q0/edit)

## Start project
```bash
make build
make APP=app1 PORT=4001 run
make APP=app2 PORT=4002 run
make APP=app3 PORT=4003 run
make APP=app4 PORT=4004 run
```

## How to test it with CURL
### Buyers
```bash
curl -d 'name=usertestA&ip=10.0.0.1&tags=decoracion, iluminacion' -X POST http://localhost:4000/api/buyers 

curl -d 'name=usertestB&ip=10.0.0.2&tags=bazar, comida' -X POST http://localhost:4000/api/buyers

curl -d 'name=usertestC&ip=10.0.0.3&tags=decoracion, iluminacion' -X POST http://localhost:4000/api/buyers
```

` curl -d 'id=1&price=10' -X POST http://localhost:4000/api/buyers_bid `

` curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:4000/api/buyer`

### Bids
```bash
 curl -d 'tags=casa, iluminacion&defaultPrice=10&duration=5&item=lampara' -X POST http://localhost:4000/api/bids
 ````

### Offer

` curl -d 'userId=0e4dbc5f-1f90-477f-9e8d-b2d0ec7cc836&bidId=9cf8dfcc-dac3-4c08-9d6b-de1d8bd98c45&price' -X POST http://localhost:4000/api/buyers/offer `

## How to test it in IEX

`conn = Phoenix.ConnTest.build_conn()`

`SubastasAppWeb.BuyerController.create(conn, %{"name" => "usertestA", "ip" => "10.0.0.1", "tags" => ["decoracion", "iluminacion"]})`

`SubastasAppWeb.BuyerController.create(conn, %{"name" => "usertestB", "ip" => "10.0.0.1", "tags" => ["bazar", "comida"]})`

`SubastasAppWeb.BuyerController.create(conn, %{"name" => "usertestC", "ip" => "10.0.0.1", "tags" => ["decoracion", "iluminacion"]})`

`SubastasAppWeb.BuyerController.get_buyers(conn, %{})`

`SubastasAppWeb.BidController.create(conn, %{"tags" => ["casa", "iluminacion"], "defaultPrice" => "10", "duration" => "1", "item" => "lampara"})`

`SubastasAppWeb.BuyerController.offer(conn, %{"userId" => "e3fd346f-c980-4100-bb5c-f4cc3d56755d", "bidId" => "4c389489-f788-49ee-8921-53f9132561a6", "price" => "20"})`

# Get bid id for offers post

`alias SubastasAppWeb.BuyerModel`

`Memento.transaction! fn -> Memento.Query.all(BuyerModel) end`

`alias SubastasAppWeb.BidModel`

`Memento.transaction! fn -> Memento.Query.all(BidModel) end`
