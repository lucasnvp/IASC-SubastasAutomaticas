# IASC-SubastasAutomaticas
Implementacion de  Arquitecturas de Software Concurrentes

## How to test it
#### Buyers
` curl -d 'name=usertest&ip=10.0.0.1&tags=[decoracion, iluminacion]' -X POST http://localhost:4000/api/buyers `

` curl -d 'id=1&price=10' -X POST http://localhost:4000/api/buyers_bid `

` curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:4000/api/buyers/get `

#### Bids
` curl -d 'tags=[decoracion, iluminacion]&defaultPrice=10&duration=100&item=lampara' -X POST http://localhost:4000/api/bids `
