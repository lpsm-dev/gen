<p align="center">
  <img alt="Logo" src="https://github.com/lpmatos/gen/blob/master/assets/Logo.png" width="250px" float="center"/>
</p>

<h1 align="center">Welcome to Gen repository</h1>

<p align="center">
  <a href="https://github.com/lpmatos/gen/releases">
    <img alt="Release" src="https://img.shields.io/github/tag/lpmatos/gen.svg?label=latest">
  </a>
  <a href="https://travis-ci.com/lpmatos/gen">
    <img alt="Build Status" src="https://travis-ci.com/lpmatos/gen.svg?branch=master">
  </a>
  <a href="https://www.codacy.com/manual/lpmatos/gen/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=lpmatos/gen&amp;utm_campaign=Badge_Grade">
    <img alt="Codacy Badge" src="https://app.codacy.com/project/badge/Grade/33544dd8a7f7408a93220542445f429e">
  </a>
  <a href="https://github.com/lpmatos/gen/blob/master/LICENSE">
    <img alt="License" src="https://img.shields.io/badge/License-Apache%202.0-blue.svg">
  </a>
  <a href="http://pkg.go.dev/github.com/lpmatos/gen">
    <img alt="GoDoc" src="https://img.shields.io/badge/pkg.go.dev-doc-blue">
  </a>
  <a href="https://goreportcard.com/report/github.com/lpmatos/gen">
    <img alt="Go Report Card" src="https://goreportcard.com/badge/github.com/lpmatos/gen">
  </a>
  <a href="https://github.com/lpmatos/gen">
    <img alt="Repository Size" src="https://img.shields.io/github/repo-size/lpmatos/gen">
  </a>
  <a href="https://github.com/lpmatos/gen/commits/master">
    <img alt="GitHub Last Commit" src="https://img.shields.io/github/last-commit/lpmatos/gen">
  </a>
</p>

>
> Gen is a GoLang CLI tool that automate your project startup
>

## ➤ Menu

<p align="left">
  <a href="#description">Description</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#how-to-contribute">How to contribute</a>
</p>

## ➤ Getting Started

If you want use this repository you need to make a **git clone**:

>
> 1. git clone --depth 1 https://github.com/lpmatos/gen.git -b master
>

This will give access on your **local machine**.

## Description 

#### Features

* Create README.
* Create project structure.
* Check project structure.
* Automate bash completion. 

## ➤ Development with Docker

Steps to build the Docker Image.

<details><summary>🐋 Build</summary>
<p>

Docker commands to build your image:

```bash
docker image build -t <IMAGE_NAME> -f <PATH_DOCKERFILE> <PATH_CONTEXT_DOCKERFILE>
docker image build -t <IMAGE_NAME> . (This context)
```
</p>
</details>

<details><summary>🐋 Run</summary>
<p>
Docker commands to run a container with yout image:

* **Linux** running:

```bash
docker container run -d -p <LOCAL_PORT:CONTAINER_PORT> <IMAGE_NAME> <COMMAND>
docker container run -it --rm --name <CONTAINER_NAME> -p <LOCAL_PORT:CONTAINER_PORT> <IMAGE_NAME> <COMMAND>
```

* **Windows** running:

```bash
winpty docker.exe container run -it --rm <IMAGE_NAME> <COMMAND>
```
</p>
</details>

## Documentation

* [Commands](./docs/Commands.md)
* [Projects](./docs/Projects.md)
* [Questions](./docs/Questions.md)
* [Technologys](./docs/Technologys.md)

## ➤ How to contribute

>
> 1. Make a **Fork**.
> 2. Follow the project organization.
> 3. Add the file to the appropriate level folder - If the folder does not exist, create according to the standard.
> 4. Make the **Commit**.
> 5. Open a **Pull Request**.
> 6. Wait for your pull request to be accepted.. 🚀
>

Remember: There is no bad code, there are different views/versions of solving the same problem. 😊

## ➤ Add to git and push

You must send the project to your GitHub after the modifications

>
> 1. git add -f .
> 2. git commit -m "Added - Fixing somethings"
> 3. git push origin master
>

## ➤ Versioning

- We currently do not have a CHANGELOG.md generated.

## ➤ License

Distributed under the Apache License. See [LICENSE](LICENSE) for more information.

## ➤ Author

👤 **Lucca Pessoa**

Hey!! If you like this project or if you find some bugs feel free to contact me in my channels:

> 
> * Email: luccapsm@gmail.com
> * Website: https://github.com/lpmatos
> * Github: [@lpmatos](https://github.com/lpmatos)
> * LinkedIn: [@luccapessoa](https://www.linkedin.com/in/luccapessoa/)
> 

## ➤ Troubleshooting

This is just a personal project created for study/demonstration purposes and to simplify my working life, it may or may not be a good fit for your project!

## ➤ Show your support

Give a ⭐️ if this project helped you!
