Phicolor
========

A unique colour picker for iOS, inspired by the well known colour wheel.

Getting Started
---------------

Clone, update submodules and open Xcode.

    git clone git@github.com:au-phiware/Phicolor-workspace.git
    cd Phicolor-workspace
    git submodule update --init
    open -a Xcode Phicolor.xcworkspace

### Seeing Red?

If the projects in Xcode's Project Navigator are red, this means that the submodules failed to download (see above). Try downloading manually: [PhiColor](https://github.com/au-phiware/PhiColor), [PhiColorSample](https://github.com/au-phiware/PhiColorSample).

Contributing
------------

Contributions to the submodules of this project are welcome (see the GitHub project pages, resp.) but please do not submit pull requests to this project.

Having said that submodules aren't as nasty as you might have heard; just try this from your working directory:

    cd PhiColor
    git checkout master
    git remote set-url origin git@github.com:your-fork/Phicolor.git

Substituting *your-fork* with your GitHub username in the URL. 

License
-------

[Apache](LICENSE)
