## Introduction

Une fois que vous avez validé votre déploiement sur la console DSO d'OVH, la suite logique est de répéter ce procédé au sein du réseau ministériel. Et dépendamment des besoins de votre application, vous aurez besoin ou non de communiquer avec les équipes de Passage2 et d'INES.


## Description

Ce projet Mock a pour but de simuler deux interfaçages: le **portail SSO passage2** et **l'API Gateway INES** au sein du ministère.

Ces deux éléments sont cruciaux pour déployer de bout en bout votre projet, voici leur caractéristiques:
- Passage2: Permettre aux utilisateurs finaux de s'authentifier à l'application de façon sécurisée et fiable.
- INES: Passerelle qui permet d'interroger des bases de données externes (fpr2, nsis, interpol, etc...) ou autres services.

---

## Mock Passage2

[...]

---

## Mock Ines

#### Pré-requis
- Créer l'autorité de certification et les certificats autosignés en utilisant les scripts bash dans l'ordre: 
    1. 1-client.sh: ce script va vous demander le common_name à inclure dans le CA, le CSR et le certificat public, dans ce format là: client.<env>.<projet>.minint.fr. L'équipe INES va matcher ce common_name de leur côté.
    2. 2-server.sh: ce script génère les certificats serveur (en l'occurence Krakend pour ce mock) et crée un manifeste kubernetes en kind secret que vous copierez dans les templates de ce même projet. 

#### Déploiement
1. Créer un projet mock depuis la console https://console.apps.c6.numerique-interieur.com/ en précisant **projet d'infrastructure**
2. Rajouter ce dépôt **helm-projects-mocks** et ajouter un environnement pour créer votre application dans ArgoCD
3. Si votre POD arrive à atteindre le service krakend en précisant le CA, le certificat public et la clé privée, et bien **Félicitations**, vous êtes prêts à communiquer réellement avec INES.

---

## Arrivage réelle au MI

#### INES

Les étapes pour communiquer avec INES sont les suivantes:
- Répéter seulement l'étape numéro 1 de la section Mock Ines / Pré-requis. Vous fournirez seulement votre CSR par mail (au contact en fin de page). Gardez quand même bien votre clé privée de côté.
- Se rendre sur ce repo: https://github.com/cloud-pi-native/helm-istio-ines, lire la documentation pour suivre les étapes afin de déployer tous les éléments d'Istio pour pouvoir communiquer avec INES, à savoir créer son SOPS Secret.

*NOTE: vous pourrez recupérer la CA d'INES en faisant un openssl s_client -connect <url-ines>:443*

---

## Contact
Vous aurez besoin de communiquer avec les équipes de Passage2 et Ines, voici leurs contacts:

#### Passage2
- nicolas.lord@interieur.gouv.fr
- lucas.dorr@interieur.gouv.fr

#### Ines
- philip.sadr-khanlou@interieur.gouv.fr
