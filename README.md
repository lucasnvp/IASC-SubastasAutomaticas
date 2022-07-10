# IASC-SubastasAutomaticas
Implementacion de  Arquitecturas de Software Concurrentes

## How to test it
#### Buyers
` curl -d 'name=usertest&ip=10.0.0.1&tags=[decoracion, iluminacion]' -X POST http://localhost:4000/api/buyers `

#### Bids
` curl -d 'tags=[decoracion, iluminacion]&defaultPrice=10&duration=100&item=lampara' -X POST http://localhost:4000/api/bids `
