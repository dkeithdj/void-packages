#!/usr/bin/zsh

echo "Checking latest version"

LATEST_VERSION=$(gh api repos/Foundry376/Mailspring/releases/latest | jq -r .tag_name)

echo "Latest version is: $LATEST_VERSION"

CURRENT_VERSION=$(cat template | grep version= | cut -c9-)

echo "Current template version is: $CURRENT_VERSION"

if [[ "$LATEST_VERSION" = "$CURRENT_VERSION" ]]; then
  echo "No update required"
  exit 0
fi

export VERSION=$LATEST_VERSION
DOWNLOAD_URL="https://github.com/Foundry376/Mailspring/releases/download/${VERSION}/mailspring-${VERSION}-amd64.deb"

echo "Downloading Mailspring to get checksum"

gh release download -R Foundry376/Mailspring -p "*amd64.deb" --output "mailspring-bin.deb"

export CHECKSUM=$(sha256sum ./mailspring-bin.deb | awk '{ print $1 }')

echo "Checksum computed"

rm ./mailspring-bin.deb

envsubst '$VERSION $CHECKSUM' < ./template.template > template

echo "Template updated"
