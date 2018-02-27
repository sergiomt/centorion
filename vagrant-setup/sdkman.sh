#!/bin/bash

curl -s "https://get.sdkman.io" | bash

su vagrant -c "source \"$HOME/.sdkman/bin/sdkman-init.sh\""

su vagrant -c "sdk version"
