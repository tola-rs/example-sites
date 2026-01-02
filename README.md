# Tola Example Sites

A collection of example sites and templates built with [Tola](https://github.com/tola-rs/tola-ssg) - a static site generator powered by Typst.

> **⚠️ Note**: CSS tooling support is still evolving. The current architecture is under consideration, and these examples are currently limited to **Tailwind CSS** only.

## Examples

Visit the live examples at: **https://tola-rs.github.io/example-sites/**

## Available Templates

| Template | Description | Demo |
|----------|-------------|------|
| [starter](./starter) | A minimal blog template with Tailwind CSS | [live](https://tola-rs.github.io/example-sites/starter/) |

## Quick Start

1. Clone this repository:
   ```sh
   git clone https://github.com/tola-rs/example-sites.git
   cd example-sites
   ```

2. Navigate to a template:
   ```sh
   cd starter
   ```

3. Install dependencies(`tola` and `tailwindcss-cli`) and start development:
   ```sh
   # Install Tola
   cargo install tola

   # Start dev server
   tola serve
   ```

## Learn More

- [Tola Documentation (coming soon)](https://github.com/tola-rs/tola-ssg)
- [Typst Documentation](https://typst.app/docs)

## Contributing

Contributions are welcome! Feel free to:

- Submit new templates
- Report issues
- Improve documentation

## License

This project(and all examples sites) is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
