# ns8-assetsmanager

Modulo NethServer 8 per **Asset Manager MSP** - gestionale per MSP
italiani (asset, clienti, contratti, ticket, fatturazione, integrazioni
con provider cloud esterni).

Questo repository contiene solo il "pacchetto" di installazione (script
di configurazione, unità systemd) - NON il codice dell'applicazione,
che vive in un'immagine separata (vedi `build-images.sh`).

## Installazione

```
add-module ghcr.io/startappsrl/assetsmanager:latest 1
```

## Configurazione

```
api-cli run module/assetsmanager1/configure-module --data '{
  "fqdn": "assetmanager.tuodominio.it",
  "lets_encrypt": true,
  "db_host": "127.0.0.1",
  "db_port": 20000,
  "db_name": "AssetManagement",
  "db_user": "assetmanager",
  "db_password": "...",
  "encryption_key": "...",
  "flask_secret_key": "..."
}'
```

Vedi `NS8_MODULE_ASSEMBLY.md` (nel progetto principale dell'app) per la
guida completa passo-passo.

## Disinstallazione

```
remove-module --no-preserve assetsmanager1
```
