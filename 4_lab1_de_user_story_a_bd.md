# Lab 1: De un user story a BD

Indicaciones:
1. Van a leer los siguientes user stories.
2. Van a hacer un diagrama E-R.
3. Van a crear una BD en un esquema `booking` en su PostgreSQL

## User stories de Booking.com
1. Es una agencia de viajes digital.
2. Tiene un web front store y una mobile app.
3. No tiene instalaciones brick-and-mortar.
4. Tiene convenio de front-store con varios hoteles.
5. Tanto hotel como Booking siguen proceso de reservación de todos los hoteles con los que tiene convenio hasta que el huésped hace check-in.
6. La reservación puede hacerse a un precio diferente a aquel en el rate normal del hotel.
7. Los precios que Booking asigna a un hotel tienen 2 orígenes:
    - O son suministrados por el hotel mediante un sistema de "hotel en convenio"
    - O Booking los obtiene mediante técnicas de "scrapping", crawleando la web, identificando ofertas de ese hotel, y jalando el precio a su sistema
8. Al final del proceso de reserva, se envían códigos de descuento de restaurantes en la misma ciudad del hotel que recibió la reserva.

Go! Go! Go!
