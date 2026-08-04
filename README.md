# orbpack

orbpack is an ***in development*** set of tools for creating and manipulating files related to PlayStation 4's packages.

It's intended to be a native-code implementation alternative to [maxton's LibOrbisPkg](https://github.com/OpenOrbis/LibOrbisPkg) that is easily compilable through Zig's build system.

Zig 0.17.0's development version is required.

Features available:

| Tool | Create | Modify |
|------|--------|--------|
| `sfo` | ✅ Yes | ❌ No |
| `gp4` | ❌ No | ❌ No |
| `pkg` | ❌ No | ❌ No |
| `pfs` | ❌ No | ❌ No |
| `rif` | ❌ No | ❌ No |

## Usage

### `sfo` tool

Creating a new SFO file requires a manifest file in ZON (Zig's equivalent of JSON) describing its fields.

Usually you only need to generate this manifest file once, then you're free to change its fields as you wish.

#### Generating a new SFO manifest file

In your command line shell, run:

```bash
orbpack sfo new-manifest param.zon
```

This will generate a pre-configured ZON file named `param.zon` in your current directory describing how your SFO should be laid out.

#### Building an SFO file

In your command line shell, run:

```bash
orbpack sfo build param.zon param.sfo
```

This will build a new SFO file named `param.sfo` in your current directory as described by the manifest file `param.zon`.

## Credits

- [maxton](https://github.com/maxton) for his [original release of LibOrbisPkg](https://github.com/maxton/LibOrbisPkg).

- [The OpenOrbis team](https://github.com/OpenOrbis) for continuing development of their [fork of maxton's LibOrbisPkg](https://github.com/OpenOrbis/LibOrbisPkg).

## License

All code here is released under the MIT license.
