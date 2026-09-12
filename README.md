# orbpack

orbpack is an ***in development*** set of tools for creating and manipulating files related to PlayStation 4's packages.

It's intended to be a native-code implementation alternative to [maxton's LibOrbisPkg](https://github.com/OpenOrbis/LibOrbisPkg) that is easily compilable through Zig's build system.

Zig 0.17.0's development version is required.

Features available:

| Tool | Create | Modify |
|------|--------|--------|
| `sfo` | ✅ Yes | ❌ No |
| `gp4` | ✅ Yes | ❌ No |
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

### `gp4` tool

#### Generating a new GP4 package manifest file

In your command line shell, run:

```bash
orbpack gp4 manifest --file eboot.bin=eboot.bin --file my_project/right.sprx=sce_sys/about/right.sprx --file anything/else/you/want=to/wherever/you/want/in/the/final/package IV0000-GAME00000_00-MYFUNGAME000000
```

This will write a `pkg.gp4` to your current directory with the files and definitions you've specified.

Each `--file` argument will create a new GP4 file entry, where the left side of the 'equal sign' (`=`) is the **source path** and the right side the **target path**.

The command **must end with your package's content ID**.

You may choose to pipe the command's output to a file. In Unix-like OSes you may do so as:

```bash
orbpack gp4 manifest --file eboot.bin=eboot.bin --file my_project/right.sprx=sce_sys/about/right.sprx --file anything/else/you/want=to/wherever/you/want/in/the/final/package IV0000-GAME00000_00-MYFUNGAME000000 > pkg.gp4
```

Where a file named `pkg.gp4` should be created in your current directory with the GP4 definitions.

## Credits

- [maxton](https://github.com/maxton) for his [original release of LibOrbisPkg](https://github.com/maxton/LibOrbisPkg).

- [The OpenOrbis team](https://github.com/OpenOrbis) for continuing development of their [fork of maxton's LibOrbisPkg](https://github.com/OpenOrbis/LibOrbisPkg).

## License

All code here is released under the MIT license.
