# nestjs-typeorm-gen

Ce script vous aide à générer des modules NestJS avec des opérations CRUD en utilisant TypeORM.

## Installation

Rendez le script exécutable :

```sh
chmod +x generator.sh
```

## Utilisation

Pour générer un seul module :

```sh
./generator.sh User
```

Pour générer plusieurs modules :

```sh
./generator.sh User Company Subscription
```

## Dépendances

Installez les dépendances requises :

```sh
npm i class-validator
npm i @nestjs/swagger
```

## Structure Générée

Le script générera la structure suivante pour chaque module :

```
src/
└── <module_name>/
    ├── <module_name>.controller.ts
    ├── <module_name>.service.ts
    ├── <module_name>.module.ts
    ├── entity/
    │   └── <module_name>.entity.ts
    └── dto/
        ├── create-<module_name>.dto.ts
        └── update-<module_name>.dto.ts
```

## Exemple

Pour générer des modules pour User, Company et Subscription, exécutez :

```sh
./generator.zsh User Company Subscription
```

Cela créera les fichiers et répertoires nécessaires pour chaque module avec des opérations CRUD de base.

by sudosu225 with ❤️
