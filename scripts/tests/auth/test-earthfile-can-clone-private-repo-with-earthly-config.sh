#!/usr/bin/env bash
set -eu # don't use -x as it will leak the private key
# shellcheck source=./setup.sh
source "$(dirname "$0")/setup.sh"

"$earthly" config git "{github.com: {auth: https, user: 'cinnamonthecat', password: '$GITHUB_PASSWORD'}}"


mkdir /tmp/earthly-6064034a-e92b-4103-baff-e00d321561eb
cat << EOF > /tmp/earthly-6064034a-e92b-4103-baff-e00d321561eb/Earthfile
FROM alpine:3.13
test-clone-https:
    GIT CLONE --branch main https://github.com/cinnamonthecat/test-private.git .
    RUN cat README.md
test-clone-ssh:
    GIT CLONE --branch main git@github.com:cinnamonthecat/test-private.git .
    RUN cat README.md
EOF

"$earthly" -VD /tmp/earthly-6064034a-e92b-4103-baff-e00d321561eb+test-clone-https
"$earthly" -VD /tmp/earthly-6064034a-e92b-4103-baff-e00d321561eb+test-clone-ssh
