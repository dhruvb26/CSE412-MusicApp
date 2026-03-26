# CSE412 Music App

Make sure you have [Bun](https://bun.sh), [Turborepo](https://turborepo.dev), and [Biome](https://biomejs.dev) installed.

Run the following command after cloning the repository:

```sh
bun install
```

## What's inside?

This Turborepo includes the following packages/apps:

### Apps and Packages

- `web`: a [Next.js](https://nextjs.org/) app
- `api`: a [FastAPI](https://fastapi.tiangolo.com/) service

### Build

To build all apps and packages, run the following command:

```
cd my-turborepo

# With [global `turbo`](https://turborepo.dev/docs/getting-started/installation#global-installation) installed (recommended)
turbo build

# Without [global `turbo`](https://turborepo.dev/docs/getting-started/installation#global-installation), use your package manager
bunx turbo build
```

You can build a specific package by using a [filter](https://turborepo.dev/docs/crafting-your-repository/running-tasks#using-filters):

```
# With [global `turbo`](https://turborepo.dev/docs/getting-started/installation#global-installation) installed (recommended)
turbo build --filter=docs

# Without [global `turbo`](https://turborepo.dev/docs/getting-started/installation#global-installation), use your package manager
bunx turbo build --filter=docs

# Example: build only the API app
bunx turbo build --filter=api
```

### Develop

To develop all apps and packages, run the following command:

```
cd my-turborepo

# With [global `turbo`](https://turborepo.dev/docs/getting-started/installation#global-installation) installed (recommended)
turbo dev

# Without [global `turbo`](https://turborepo.dev/docs/getting-started/installation#global-installation), use your package manager
bunx turbo dev
```

You can develop a specific package by using a [filter](https://turborepo.dev/docs/crafting-your-repository/running-tasks#using-filters):

```
# With [global `turbo`](https://turborepo.dev/docs/getting-started/installation#global-installation) installed (recommended)
turbo dev --filter=web

# Without [global `turbo`](https://turborepo.dev/docs/getting-started/installation#global-installation), use your package manager
bunx turbo dev --filter=web

# Example: run only the API app
bunx turbo dev --filter=api
```
