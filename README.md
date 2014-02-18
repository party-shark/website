# Party Shark [![Build Status](https://travis-ci.org/party-shark/website.png?branch=master)](https://travis-ci.org/party-shark/website)

This is the website for Party Shark, we are a World of Warcraft raiding guild on Stormreaver Horde.

## Setup

This application is build under the assumption the following dependencies are installed. `Postgres 9.3.2`, `Ruby 2.1`, `Rails 4.0`.

To run locally:
```
git clone https://github.com/party-shark/website.git
cd website
bundle install
rake db:create && rake db:migrate && rake db:seed
foreman start
```

## Database

### Pull the Database

```
curl -o latest.dump `heroku pgbackups:url`  # Download the latest backup.
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d party_shark_development latest.dump
```

## Conventions

It's important to hold to conventions, and implement things in a consistent way. This allows for sanity around bug fixes, and changing things in general.

### Ruby

TODO: Write this.

### Coffeescript

TODO: Write this.

### HTML & CSS

Following the conventions of Rails, there will be a folder for pages for every controller. Files in these directories either correspond to an action name from the controller, or are a partial, starting with a `_`.

- Never user ids for styling. Ids are for scripting only.
- Classes **MUST** be styled for any page. Never give a class styles just for a specific page.
- Style the layout of a page by the page's html elements.


#### Example Page

```html
<div class="page">
    <section class="content">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
        consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
        cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
        proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
    </section>

    <aside>
        <p>This is just some latin...</p>
    </aside>
</div>
```

```scss
.<controller-name>.<action-name>,
.<controller-name>.<other-action-name> {
  section {
    @include span-columns(8);
  }

  aside {
    @include span-columns(4);
    @include omega();
  }
}
```