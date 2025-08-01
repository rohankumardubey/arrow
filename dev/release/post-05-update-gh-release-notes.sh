#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -e
set -o pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

. "${SOURCE_DIR}/utils-env.sh"

VERSION=$1
REPOSITORY="apache/arrow"
TAG="apache-arrow-${VERSION}"
WORKFLOW="release.yml"

# Wait for the GitHub Workflow that creates the GitHub Release
# to finish before updating the release notes.
"${SOURCE_DIR}/utils-watch-gh-workflow.sh" "${TAG}" "${WORKFLOW}"

# Update the Release Notes section
RELEASE_NOTES_URL="https://arrow.apache.org/release/${VERSION}.html"
RELEASE_NOTES="Release Notes URL: ${RELEASE_NOTES_URL}"
gh release edit ${TAG} --repo ${REPOSITORY} --notes "${RELEASE_NOTES}" --verify-tag
