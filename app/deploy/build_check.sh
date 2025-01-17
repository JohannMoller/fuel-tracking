#!/bin/bash

release_branch="main"
search_phrase="changeset-release/$release_branch"
# Retrieve the latest commit message
commit_message=$(git log -1 --pretty=%B)

# Print commit branch
echo "VERCEL_GIT_COMMIT_REF: $VERCEL_GIT_COMMIT"
echo "commit_message: $commit_message"
  # Dont build main, we trigger it only with releases
if [[ "$VERCEL_GIT_COMMIT_REF" == $release_branch  ]] ; then
  # Check if the commit message contains the search phrase. If found, continue with build, else don't
  if [[ "$commit_message" == *"$search_phrase"* ]]; then
    # Build if we have a tag
    echo "✅ - Build can proceed, changeset release on $release_branch"
    exit 1;
  fi

  echo "🛑 - Build cancelled, $release_branch build, not changesets"
  exit 0;

else
  # Build everything else
	echo "✅ - Build can proceed, not $release_branch and or changeset"
  exit 1;
fi
