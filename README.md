<a id="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Unlicense License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Sgalvin36/creative_cooking_api">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Creative Cooking API</h3>

  <p align="center">
    The backbone to a new take on handling recipes and the potential modifications an experimenter can come up with!
    <br />
    <!-- <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a> -->
    <!-- <br />
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template">View Demo</a>
    &middot;
    <a href="https://github.com/othneildrew/Best-README-Template/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/othneildrew/Best-README-Template/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p> -->
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com) -->

Recipes are frequently filled with all sorts of information that a user doesn't want mixed in with the things that they are actually looking in for. In an effort to get to the things that really make or break a good recipe, the api is designed around the recipe itself and the potential modifications that a user can find submitted by other users on the platform. It can be overly frustrating to try a recipe, find that its missing a little something something, only to go back and look in the comments and find multiple people sharing the same realization and their potential solutions (**_which should almost always be more garlic_**). This database is designed around primarily storing those tidbits of information and making them super accessible to the user.

<p align="left">
Here's what is inside:
</p>

- A database designed around building a cookbook and adding multiple modifications to recipes
- GraphQL integration to make queries less difficult
- Pundit, JWT, and Rolify to take care of authentication and authorization

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

- [![Ruby][Ruby]][Ruby-url]
- [![Rails][Ruby-on-Rails]][Ruby-on-Rails-url]
- [![GraphQL][GraphQL]][GraphQL-url]
- [![PostgreSQL][PostgreSQL]][PostgreSQL-url]
<!-- * [![Gitlab-CI][Gitlab-CI]][Gitlab-CI-url] -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

### Prerequisites

Get started by making sure that ruby is installed on your computer so that you'll be able to use bundler with the repo

- Check if Ruby is installed
  ```sh
  ruby -v
  ```
  If you get an error or its not found, install it with
  For MacOS:
  ```
  brew install ruby
  ```

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/sgalvin36/creative_cooking_api
   ```
2. Install gems
   ```sh
   bundle install
   ```
3. Build the database
   ```sh
   rails db:{drop,create,migrate}
   ```
4. Seed the database (if needed for further development)
   ```sh
   rails db:seed
   ```
5. Change git remote url to avoid accidental pushes to base project
   ```sh
   git remote set-url origin github_username/repo_name
   git remote -v # confirm the changes
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->

## Usage

### Signing in a user:

Endpoint: `/login`
<br><br>
Required variables:

```json
{
    "password": "TheBestPassword"
    **"username": "test user"
    **"email": "theBestEmail@example.com"
}
```

\*\* Either email or username is required to access the login endpoint.
<br><br>
Expected Response:

```json
{
  "token": "super long encrypted token",
  "user": {
    "id": 1,
    "first_name": "Maria",
    "last_name": "Heaney",
    "user_name": "test user",
    "password_digest": "equally encrypted password digest",
    "key": null,
    "created_at": "2025-02-14T21:54:19.783Z",
    "updated_at": "2025-02-14T21:54:19.783Z"
  },
  "roles": [
    {
      "id": 1,
      "name": "user",
      "resource_type": null,
      "resource_id": null,
      "created_at": "2025-02-14T21:54:19.426Z",
      "updated_at": "2025-02-14T21:54:19.426Z"
    }
  ]
}
```

### Querying for recipes:

#### **All Recipes**

Endpoint: `/graphql`
<br><br>
Fetch all recipes optionally filtered by a search string, and support pagination with limit and offset. <br>
Required variables:

```json
{
  "query": "query GetAllRecipes($search: String, $limit: Int, $offset: Int) { allRecipes(search: $search, limit: $limit, offset: $offset) { id name image servingSize } }",
  "variables": { "search": "chicken", "limit": 10, "offset": 0 },
  "operationName": "GetAllRecipes"
}
```

<br>

**Expected Response:**

```json
{
  "data": {
    "recipes": [
      {
        "id": "1",
        "name": "360 Deli"
      },
      {
        "id": "2",
        "name": "WBL House"
      },
      {
        "id": "3",
        "name": "Fat Grill"
      },
      {
        "id": "4",
        "name": "Sugar Deli"
      }
    ]
  }
}
```

#### **Personal Cookbook**

Endpoint: `/graphql`
<br><br>
If you want to get all the recipes associated to the logged in users cookbook. <br>
**Required variables:**

```json
{
  "query": "query GetPersonalCookbook { personalCookbook { id name image servingSize } }",
  "variables": {},
  "operationName": "GetPersonalCookbook"
}
```

<br><br>
Expected Response:

```json
{
  "data": {
    "recipes": [
      {
        "id": "1",
        "name": "360 Deli"
      },
      {
        "id": "2",
        "name": "WBL House"
      },
      {
        "id": "3",
        "name": "Fat Grill"
      },
      {
        "id": "4",
        "name": "Sugar Deli"
      }
    ]
  }
}
```

#### **Random Recipes**

Endpoint: `/graphql`
<br><br>
Fetch a random amount of recipes. Pass the number as the count variable (optional). <br>

**Required variables:**

```json
{
  "query": "query GetRandomRecipes($count: Int) { randomRecipes(count: $count) { id name image servingSize } }",
  "variables": { "count": 5 },
  "operationName": "GetRandomRecipes"
}
```

<br><br>
Expected Response:

```json

```

#### **Single Recipe**

Endpoint: `/graphql`
<br><br>
Fetch a single recipes full information by ID. <br>

**Required variables:**

```json
{
  "query": "query GetRecipe($id: ID!) { recipe(id: $id) { id name image servingSize recipeInstructions { instructionStep instruction } recipeIngredients { quantity measurement { unit } ingredient { name } } } }",
  "variables": { "id": "RECIPE_ID_HERE" },
  "operationName": "GetRecipe"
}
```

<br><br>
Expected Response:

```json

```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->

## Roadmap

- [x] Add Changelog
- [x] Add back to top links
- [ ] Add Additional Templates w/ Examples
- [ ] Add "components" document to easily copy & paste sections of the readme
- [ ] Multi-language Support
  - [ ] Chinese
  - [ ] Spanish

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Top contributors:

<!-- <a href="https://github.com/othneildrew/Best-README-Template/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=othneildrew/Best-README-Template" alt="contrib.rocks image" />
</a> -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## License

Distributed under the Unlicense License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

## Contact

Shane Galvin - Sgalvin36@gmail.com

Project Link: [https://github.com/Sgalvin36/creative_cooking_fe](https://github.com/Sgalvin36/creative_cooking_fe)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

- [Choose an Open Source License](https://choosealicense.com)
- [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
- [Malven's Flexbox Cheatsheet](https://flexbox.malven.co/)
- [Malven's Grid Cheatsheet](https://grid.malven.co/)
- [Img Shields](https://shields.io)
- [GitHub Pages](https://pages.github.com)
- [Font Awesome](https://fontawesome.com)
- [React Icons](https://react-icons.github.io/react-icons/search)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/Sgalvin36/creative_cooking_api.svg?style=for-the-badge
[contributors-url]: https://github.com/Sgalvin36/creative_cooking_api/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Sgalvin36/creative_cooking_api.svg?style=for-the-badge
[forks-url]: https://github.com/Sgalvin36/creative_cooking_api/forks
[stars-shield]: https://img.shields.io/github/stars/Sgalvin36/creative_cooking_api.svg?style=for-the-badge
[stars-url]: https://github.com/Sgalvin36/creative_cooking_api/stargazers
[issues-shield]: https://img.shields.io/github/issues/Sgalvin36/creative_cooking_api.svg?style=for-the-badge
[issues-url]: https://github.com/Sgalvin36/creative_cooking_api/issues
[license-shield]: https://img.shields.io/github/license/Sgalvin36/creative_cooking_api.svg?style=for-the-badge
[license-url]: https://github.com/Sgalvin36/creative_cooking_api/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: www.linkedin.com/in/shane-galvin36
[product-screenshot]: images/screenshot.png
[Ruby-on-Rails]: https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white
[Ruby-on-Rails-url]: https://guides.rubyonrails.org/
[Ruby]: https://img.shields.io/badge/Ruby-%23CC342D.svg?&logo=ruby&logoColor=white
[Ruby-url]: https://ruby-doc.org/
[GraphQL]: https://img.shields.io/badge/GraphQl-E10098?style=for-the-badge&logo=graphql&logoColor=white
[GraphQL-url]: https://graphql.org/
[PostgreSQL]: https://img.shields.io/badge/postgresql-4169e1?style=for-the-badge&logo=postgresql&logoColor=white
[PostgreSQL-url]: https://www.postgresql.org/docs/
[GitLab-CI]: https://img.shields.io/badge/GitLab%20CI-FC6D26?logo=gitlab&logoColor=fff
[GitLab-CI-url]: https://docs.gitlab.com/ee/ci/
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com

```

```
