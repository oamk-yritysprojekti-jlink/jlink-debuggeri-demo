# Rakennusohjeet

Debuggausta helpottamaan
`west build -t menuconfig`
ja aseta

```
Build and Link Features ---> Compiler Options ---> Optimization Level (Optimize debugging experience)
```

Rakenna nRF5340dk alustalle `west build -b nrf5340dk_nrf5340_cpuapp` ja flashaa `west flash --erase`

Kansiossa oleva .gdbinit lataa .ELF tiedoston automaattisesti ja yhdistää palvelimeen portilla `:2331`
