# Tools - WordPress Parse Theme CSS

David Williamson @ Varilink Computing Ltd

------

This repository provides the *wp-parse-theme-css* Docker Compose service to provide the means to generate custom CSS for the theme using Sass, both at a global level and for block types, and to insert that generated CSS into the theme's `theme.json` file.

## Contents

| File/Directory                       | Description                                                      |
| ------------------------------------ | ---------------------------------------------------------------- |
| `app.pl`                             | Perl script that does the work of this tool.                     |
| `docker-compose.yml`<br>`Dockerfile` | Docker files that wrap `app.pl` within a Docker Compose service. |

## Installation

Install with your WordPress project's Docker Compose repository at the path `tools/wordpress-parse-theme-css/`.

## Usage

In order to use it you need the following content within the `theme/` directory of your WordPress project.

- `theme/scss/`

  This directory should contain `.scss` files that require Sass pre-processing and possibly `.css` files, which don't require Sass pre-processing. If you want to set global custom CSS for your theme, then one of the files must be either `theme/scss/global.scss` or `theme/scss/global.css`.

  You can also define block specific custom CSS using a directory structure that maps to the block namespaces and names for the blocks you are targetting; for example, to define custom CSS for the `core/list-item` block you would must use a file `theme/scss/blocks/core/list-item.scss` or `theme/scss/blocks/core/list-item.css`.

  In order for these block specific SCSS or CSS files to be syntactically correct, you should wrap the rules inside them within a dummy, custom selector; for example:

```css
block-style {
  list-style-type: none;
}
```

- `theme/css/`

  This directory will hold the custom CSS generated using Sass. Since the CSS files within it are generated content they do not need to be tracked using Git. However, the directory structure within this directory must match that within `theme/scss`.

To use the *wp-css*, first create the SCSS and CSS files within the correct directory structure within `theme/scss/`. You can then use the Varilink [Tools - NPM](https://github.com/varilink/tools_npm) repository to install the `npm` and `npx` services into your project repository as a tool, which you can then use to install the `sass` package to generate CSS from your SASS.

It's a good idea to first generate the CSS in expanded style to manually preview it:

```sh
docker-compose run --rm npx sass --no-source-map scss:css
```

When you're happy with the CSS, then you must regenerate it ready for insertion into your `theme/theme.json` file, this time with the `--no-charset` and `--style=compressed` options set for the `sass` command:

```sh
docker-compose run --rm npx sass --no-charset --no-source-map --style=compressed scss:css
```

This command will then parse your project's `theme/theme.json` file, remove any `css` attributes that it already contains, and insert `css` attributes containing the CSS from the `.css` files within the `theme/css/` directory at the appropriate places in the `theme/theme.json` file's JSON structure:

A working example of this tool in use in a project can be found in the Varilink [Website - Docker](https://github.com/varilink/website_docker) repository.
