# tosdump

Continuing off the king god general emperor meldavy's work (https://github.com/meldavy)

TODSDump.exe
TOSDump.exe is used to extract and dump all ipf files.

Use TOSDump.exe <path-to-tos-dir> to use. It detects tos dir by checking for /data and /patch dir.

But don't actually use real tos dir, because it uses IPKUnpacker, which decrypts all ipf. Copy /data and /patch dir to any folder, and use that dir as the argument to TOSDump.

Because IPKUnpacker's extension-based extraction seems to be broken and extracts every file regardless of extension (maybe I just have a bad version), TOSDump performs cleanup on the resulting extract dir by deleting all non-lua and xml files, and then deleting all empty directories recursively. Thus, only XML and lua files will remain.

files can be found under https://github.com/meldavy/tos-ipf/releases
