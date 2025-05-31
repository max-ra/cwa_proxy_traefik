# README

This README would normally document whatever steps are necessary to get your application up and running.

## What is this repository for?

* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

## How do I get set up?

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### digest auth

THis repository supports authentification via digest auth. This sould only be used in low trafic environment e.g. backend configuration or promehteus configuraiton endpoints. Digest auth could be transported securly over unencrypted http communication. The plaintext passwords get hashed befor transportation over the the wire.

To get a new auth entry generate it with the following command. Be aware that this cammand saltes the password with the prase **traefik**

```bash
htdigest -c auth.txt traefik rauchmx
```

The entry can be moved to the appropiate place in the configruation management sytem or you have to put it in the **.env** file.

## Contribution guidelines

* Writing tests
* Code review
* Other guidelines

## Who do I talk to?

* Repo owner or admin
* Other community or team contact
