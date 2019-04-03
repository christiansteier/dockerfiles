## YunoHost Docker image

Run Yunohost in Docker on (AMD64) server. This image is inspired by [https://github.com/domainelibre/YunohostDockerImage](https://github.com/domainelibre/YunohostDockerImage).

### Pre-requirements 

**The linux docker host must run systemd.**

## Environment variables

### Postinstall
- **POSTINTALL** : Set "yes" to create a simple start script to run postinstall with HTTPS certificate *(default: "no")*
- **DOMAIN** : Domain for postinstall  *(default: "yunohost.local")*
- **PASSWORD** : Admin password for postinstall *(default: none)*
- **DUMMYNIC** : Create dummy interface with external static ip *(default: "no")*
### External SMTP relay
- **SMTPRELAY** : Set "yes" to configure postfix to use an external SMTP server *(default: "no")*
- **SMTPRELAYDOMAIN** : SMTP domain like smtp.domain.tld *(default: "none")*
- **SMTPRELAYLOGIN** : Your login *(default: "none")*
- **SMTPRELAYPASSWORD** : Your password *(default: "none")*
