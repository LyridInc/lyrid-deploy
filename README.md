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

instanceid:
    description: 'Deploy to specific cluster. Input your UniqueInstanceID. (ex: a1b2c3d4)'
    default: ''
  regionid:
    description: 'Deploy to specific RegionID. if no deployment strategy is found, defaulted to (uswest1)'
    default: ''
  distributed:
    description: 'Enable distributed deployment'
    default: ''
## Options
You can configure the deploy to heroku passing some options to the action

| Name            | Type     | Description                                                                                                                                  | Example                                              | Required | Default         |
|-----------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------|----------|-----------------|
| lyrid-key       | string   | Lyrid account's access key for authentication. Visit your profile settings on Lyrid to obtain.                                               | "67gccd678ef76efv678fv"                              | true     | -               |
| lyrid-secret    | string   | Lyrid account's access secret for authentication. Visit your profile settings on Lyrid to obtain.                                            | "6hFJIeUFN3Uqvbhr0BuzKfiUMZjdBEEJcQY7yWHIyOZc8JsomG" | true     | -               |
| instanceid      | string   | Deploy to specific cluster. Input your UniqueInstanceID.                                                                                     | "a1b2c3d4"                                           | false    | -               |
| instancetag     | string   | Deploy to multiple cluster according to tag.                                                                                                 | "productioncluster"                                  | false    | -               |
| regionid        | string   | Deploy to specific RegionID. if no deployment strategy is found, defaulted to (uswest1)                                                      | "apsoutheast1"                                       | false    | -               |
| distributed     | boolean  | Enable distributed deployment                                                                                                                | "true"                                               | false    | -               |