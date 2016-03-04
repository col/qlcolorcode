Here are some questions I expect to get.

  1. **How will I know when a new version is released?**
> > Google offers an RSS feed for the "Downloads" page of this project for you to subscribe to.  You can do this in Mail.app, for example.  You can also use the [RSS FWD](http://rssfwd.com) service to have that feed forwarded to you as e-mail if you're not hot on RSS (but really, you should be).
  1. **Why doesn't it highlight my Bozoscript .bozo files?**
> > The plugin tells the system, "I can display anything of type public.source-code" but it's up to the system (Launch Services, to be precise) to figure out what extensions, mime-types, and such have that type.  For extensions like .c or .py the system already knows that they're source code, but for .bozo and other "exotic" file types somebody needs to tell it.  I've included a few random "interesting" file types in the Info.plist file in the plugin's bundle to take care of this, but it's probably not wise to include everything that Highlight can handle.  Why not?  Well, if two different entities make conflicting claims on a given file extension then only one of them can win.  For the gritty details, see [Apple's UTI docs](http://developer.apple.com/documentation/Carbon/Conceptual/understanding_utis/index.html) and [this message](http://lists.apple.com/archives/Quicklook-dev/2007/Nov/msg00043.html).
  1. **QLCC used to handle my .xyz files but suddenly they stopped working!**
> > This happens to me too.  I suspect sunspots or other disturbances of the luminiferous ether are to blame.  Your best bet is to try the procedures outlined in FAQ 5.  See also ImportantNoteForXcodeUsers.
  1. **How can I figure out what QL plugin is being used for a file?**
> > You can use the `qlmanage` tool to figure out what type the OS thinks a given file is and what generator it uses for it.  Here's a Leopard example:
```
[n8gray@golux]% qlmanage -p Notes.txt 2>&1 | grep 'Generator used'
2008-01-07 13:50:57.476 qlmanage[56917:5f03] [QL] Previewing /Users/n8gray/src/flickr/Notes.txt. Content type UTI: public.plain-text. 
Generator used: <QLGenerator /System/Library/Frameworks/QuickLook.framework/Resources/Generators/Text.qlgenerator>
```
> > In Snow Leopard the command has changed.  You cannot use grep to isolate the line you're interested in.  (Why, Apple, why?)  Luckily it only produces a handful of lines instead of many screens worth:
```
[n8gray@golux]% qlmanage -d 1 -p beep.c
Testing Quick Look preview with files:
        beep.c
...
[DEBUG] Previewing /Users/n8gray/src/beep/beep.c. Content type UTI: public.c-source. 
Generator used: <QLGenerator /Users/n8gray/Library/QuickLook/QLColorCode.qlgenerator>
...
```
> > If you're looking at a file type that Launch Services doesn't know about, you'll see that the `Content type UTI` gets set to dyn.(random junk).  For example:
```
2009-01-07 13:03:05.146 qlmanage[18253:5f03] [QL] Previewing /Users/n8gray/src/QLColorCode/foo.bozo. Content type UTI: dyn.ah62d4rv4ge80e554r6. 
Generator used: <QLGenerator /Users/n8gray/Library/QuickLook/EPSQLPlugIn.qlgenerator>
```
  1. **I added a Bozoscript section to Info.plist but my .bozo files _still_ quicklook like generic icons!  WTF?**
> > If the command from the previous FAQ tells you that the UTI is dyn.something or the generator used is not QLColorCode, then you probably need to nudge Launch Services so it knows something has changed.  Here are some things to try:
      * Read ImportantNoteForXcodeUsers
      * Move the plugin to a new location, then move it back.
      * `qlmanage -r` will reset QuickLook's caches.
      * `touch ~/Library/QuickLook/QLColorCode.qlmanager` may get Launch Services' attention.
      * `/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f -v ~/Library/QuickLook/QLColorCode.qlmanager` should _really_ get Launch Services' attention, but it's hard to type.
  1. **Can you add official support for Bozoscript?**
> > [If it's supported by Highlight](http://www.andre-simon.de/doku/highlight/en/highlight_langs.html) then the answer is probably yes.  If it's not supported by highlight then the answer is also probably yes, but only if you're willing to write the highlight support.  Assuming the language is supported by highlight, I'll need some info about the language in order to create a Universal Type Identifier for it:
      1. The name of the language
      1. The file extension(s) it uses
      1. The website of the organization in charge of the language (if possible)
      1. (optional but potentially very helpful) The Info.plist file from a major Mac software package that handles files of this language.
> > Once you've got that information, mosy on over to the [Issues](http://code.google.com/p/qlcolorcode/issues/list) page and file an issue.  That is the **highly** preferred way for you to make new language requests.  If you send them as e-mail, leave them as comments on my blog, or leave them in other random places there's a very good chance I'll overlook or forget about them.
  1. **I thought QLColorCode used [Pygments](http://pygments.org) as its highlighting engine.**
> > Sorry, that's not a question.  :-)  Actually, it did use Pygments, but now it uses Highlight.  Pygments is a nice project, but the Highlight engine is about 10x faster and supports more languages.  One nice aspect of QLColorCode's design is that the highlighting engine can be swapped out quite easily if something better comes along.
  1. **This is awful!  How do I uninstall QLColorCode?**
> > Just drag the bundle from `~/Library/QuickLook` or `/Library/QuickLook` into the trash.