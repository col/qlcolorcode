# Important information on using QLColorCode with Xcode v3.2 and later #

Xcode 3.2 (the version shipped with Snow Leopard) includes a Quick Look plugin that highlights source code.  It only highlights a few languages, so you probably still want to use QLColorCode.  However, the Quick Look server tends to pick the Xcode plugin over QLCC.  This means that for any source code file aside from .c, .m, and the other languages that Xcode understands you'll see a plain text preview with no highlighting.  To get QLCC to work properly you'll need to disable the Xcode plugin.

# Symptoms #

If you're having this problem you'll notice that:

  1. `.c`, `.m`, and other "Xcode-approved" file types have highlighting.  (The Xcode plugin handles them)
  1. More obscure file types (`.ml`, `.scala`, `.as`, etc) do **not** have highlighting.  (The Xcode plugin knows they're source code, thanks to QLCC, but doesn't know how to highlight them.)  To test this, put the following into a file called `foo.ml` and quick look it.  If the `open` keywords are not highlighted then you're experiencing the problem:
```
open Foo
open Bar
```
  1. `.plist` files display as XML, with highlighting.  (Xcode's plugin doesn't accept `.plist` files, so QLCC still gets them.  If this doesn't work then QLCC isn't installed properly.)

# Scripts #

**I have created two Applescripts to easily disable and restore the Xcode plugin with a simple double-click.**  They can be found in the Downloads section, named `QLColorCodeScripts`.  If you want to know how to do it by hand, read on.

# Details #

The Xcode plugin is installed at:
```
/Developer/Applications/Xcode.app/Contents/Library/QuickLook/SourceCode.qlgenerator
```

The simplest way to disable it is to open Terminal.app and run these commands:
```
f=/Developer/Applications/Xcode.app/Contents/Library/QuickLook/SourceCode.qlgenerator
sudo mv $f.disabled /tmp/   # Move aside any previously disabled version
sudo mv $f $f.disabled
```

This will rename the plugin to `SourceCode.qlgenerator.disabled`, which will prevent it from being loaded by `quicklookd`.  **You will need to repeat this if you upgrade or reinstall Xcode.**

# A Note on Code Signing #

The Xcode application is cryptographically signed. Disabling the `SourceCode.qlgenerator` plugin is safe: it will **NOT** invalidate the signature.  You can confirm this by using the `codesign` command after disabling the plugin:

```
[n8gray@golux]% codesign -vv /Developer/Applications/Xcode.app
/Developer/Applications/Xcode.app: valid on disk
/Developer/Applications/Xcode.app: satisfies its Designated Requirement
```