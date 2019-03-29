## YunoHost Docker image

Run Yunohost in Docker on (AMD64) server. This image is inspired by [https://github.com/domainelibre/YunohostDockerImage](https://github.com/domainelibre/YunohostDockerImage).

### Pre-requirements 

**The linux docker host must run systemd.**

## Environment variables

- **POSTINTALL** : Set "yes" to create a simple script to run postinstall with HTTPS certificate *(default: "no")*
- **DOMAIN** : Domain for postinstall  *(default: "yunohost.local")*
- **PASSWORD** : Admin password for postinstall *(default: "yunohost")*
- **DUMMYNIC** : Create dummy interface with external static ip *(default: "no")*

### Post-installation

* If the environment variables are set correctly, you can just do that

```
yunohost-postinstall
```

* ... or without variables

```
yunohost tools postinstall -d test.local -p secret
```
