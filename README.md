Playlist Everything Facebook Player
===

## Setting up the Development Environment

These are the steps to get you up and running:

 - Run a npm install in the directory.
 - Setup sublime text build system for coffeescript.
 - Voila! you should be good to go.

An alternative to using the sublime text build system for coffeescript is to just run the coffee compiler from the commandline.

## CoffeeScript build system

 - Install the sublime text package manager (if you haven't already, go for it, its great! http://wbond.net/sublime_packages/package_control).
 - Install the SublimeOnSaveBuild package through the package manager.
 - Browse to your user defined packages (Preferences > Browse Packages...).
 - Modify the SublimeOnSaveBuild.sublime-settings file to include coffee in its filename_filter. the file should look like this:

        {
            "filename_filter": "\\.(css|js|coffee|sass|less|scss|jade)$",
            "build_on_save": 1
        }

 - In sublime text now go to Tools > Build System > New Build System, which will create an empty build system. Paste the following code into the file and save it:

        {
           "cmd": [
                    "coffee", "--compile", "--output", "./../bin", "$file"
            ],
            "path": "/usr/local/bin:$PATH",
            "working_dir": "$file_path",
            "selector": "source.coffee"
        }

 - You should now be all set up and ready to contribute to the project!

**Important!** The build system above is designed for unix systems. If you are on windows, it will probably be somewhat different. Catch us on our IRC channel if you need any help.

**Another! Important! Notice!** If you have any coffeescript package installed already in sublime, as for example the "CoffeeScript" package for neat syntax highlighting and stuff, you will probably have a build system reacting to coffeescript source files already. If you would like to use our build system, remember to comment out the existing coffeescript build system so they won't collide.

## Contribute? Chat? Yell at us? Drink a beer?

Find us on the IRC freenode server! Channel #playlisteverything