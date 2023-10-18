Demo ja aloitusohje nordicin laitteiden debuggaamiseen J-Linkin ja gdb:n avulla.

`opetusdemo/` sisältää ensimmäisessä videossa käytetyn yksinkertaisen ohjelman.

`asmdemo/` sisältää toisen videon loppuosassa tehdyn ohjelman, jossa ohjataan LEDiä asm koodilla.

Huom! Erittäin tärkeää, että tämä rakennetaan non-secure applikaatioksi.
Jos halutaan rakentaa secure applikaationa, pitää tiedostosta `asmdemo/src/gpio.s` vaihtaa rivi 16
`.equ    GPIO_BASE, 0x40842500` muotoon `.equ    GPIO_BASE, 0x50842500`

### Rakennusohje

Ensin, aja `west build -b nrf5340dk_nrf5340_cpuapp_ns`, jonka jälkeen ohjelmoi levy komennolla `west flash --erase`
