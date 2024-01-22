#!/usr/bin/zsh

echo "Checking latest version"

LATEST_VERSION=$(gh api repos/microsoft/vscode/releases/latest | jq -r .tag_name)

echo "Latest version is: $LATEST_VERSION"

CURRENT_VERSION=$(cat template | grep version= | cut -c9-)

echo "Current template version is: $CURRENT_VERSION"

if [[ "$LATEST_VERSION" = "$CURRENT_VERSION" ]]; then
  echo "No update required"
  exit 0
fi

export VERSION=$LATEST_VERSION
DOWNLOAD_URL="https://update.code.visualstudio.com/${VERSION}/linux-x64/stable"

echo "Downloading VScode to get checksum"

# gh release download -R microsoft/vscode -A "tar.gz" --output "vscode-bin.tar.gz"

curl -L -o vscode-bin.tar.gz ${DOWNLOAD_URL}

export CHECKSUM=$(sha256sum ./vscode-bin.tar.gz | awk '{ print $1 }')

echo "Checksum computed"

rm ./vscode-bin.tar.gz

envsubst '$VERSION $CHECKSUM' < ./template.template > template

echo "Template updated"
