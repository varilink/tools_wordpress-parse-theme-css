# Tools - Perl

David Williamson @ Varilink Computing Ltd

------

This repository provides a library of Perl scripts that I use in my project development. It exposes those scripts via a Docker Compose service.

## Contents

| File/Directory | Description                                   |
| -------------------------------------------------------------- | -------------------------------------------------------------------- |
| `pl/`                                                          | Directory that holds the provided Perl scripts.                      |
| `docker-compose.yml`<br>`docker-entrypoint.sh`<br>`Dockerfile` | Docker Compose configuration to expose the Perl scripts as services. |

## Installation

Install as a submodule within your WordPress project repository at the path `tools/perl/`.

## Usage

Configure Docker Compose services within your WordPress project repository that use the scripts provided by the tool; for example:

```yaml
fobv-site-theme-3:
  image: varilink/tools/perl
  command: wp-theme-css-to-json.pl
  volumes:
    - ./themes/fobv-site/:/workdir/
```

This example is taken from the Varilink [FoBV - WordPress](https://github.com/varilink/fobv_wordpress) repository.

## Scripts

### wp-theme-css-to-json.pl

In order to use this script you need the following files within a directory of your WordPress project that defines a custom theme.

- `/theme.json` (mandatory)
- At least one `.css` file, which can either be `/theme.json.css` or files within the `/blocks` directory of your theme whose name is `[BLOCK_NAMESPACE]/[BLOCK_NAME].json.css`

This script parses the `/theme.json` file and merges the CSS from any `.css` files that it finds into it as the values of `css` attributes. If there is a `/theme.json.css` file it will use that as the value of the global `css` attribute. If it finds files in the `/blocks` directory it will use those as the value of block specific `css` attributes matching to the block namespace and name; for example, to define custom CSS for the `core/list-item` block you would must use a file `blocks/core/list-item.css`.

In order for these block specific SCSS or CSS files to be syntactically correct, you should wrap the rules inside them within a dummy, custom selector; for example:

```css
block-style {
  list-style-type: none;
}
```

A good working example of this script in use in a project can be found in the Varilink [Website - Docker](https://github.com/varilink/website_docker) repository.
