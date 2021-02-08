# lyrid-deploy
A GitHub Action for deploying on Lyrid Serverless Platform

## Basic Example
In this example you must have a lyrid definition file (.lyrid-definition.yml) in the project directory and create the following file (.github/workflows/main.yml)

```yaml
name: Deploy

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-20.04
    steps:
      - uses: actions/checkout@v2
      - uses: LyridInc/lyrid-deploy@v0.1.1 # This is the action
        with:
          lyrid-key: ${{secrets.LYRID_API_KEY}}
          lyrid-secret: ${{secrets.LYRID_API_SECRET}} 
```

## Options
You can configure the deploy to heroku passing some options to the action

| Name            | Type     | Description                                                                                                                                  | Example                             | Required | Default                |
|-----------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|----------|------------------------|
| lyrid-key  | string   | Lyrid account's access key for authentication. Visit your profile settings on Lyrid to obtain.                                                    | "67gccd678ef76efv678fv"           | true     | -                      |
| lyrid-secret    | string   | Lyrid account's access secret for authentication. Visit your profile settings on Lyrid to obtain.                                                                                                                      | "JKB87987KHJKJ"                 | true     | -                    
