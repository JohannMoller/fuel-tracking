#!/bin/bash

# Print commit branch
echo "VERCEL_GIT_COMMIT_REF: $VERCEL_GIT_COMMIT_REF"

  # Dont build main, we trigger it only with releases
if [[ "$VERCEL_GIT_COMMIT_REF" == "main"  ]] ; then
  # Define the phrase to search for
  search_phrase="changeset-release/main"
  # Retrieve the latest commit message
  commit_message=$(git log -1 --pretty=%B)
  echo $commit_message

  # Print commit message of last commit
  # Search for text 'Version Packages', and redirects errors to /dev/null (suppress errors when not matching text)
  # git show --oneline -s HEAD | grep 'Version Packages' 2> /dev/null

  # Check exit status of grep command. If status 0 ('Version Packages') was found, continue with build, else don't
  # if [ $? -eq 0 ]; then
  if [[ "$commit_message" == *"$search_phrase"* ]]; then
    # Build if we have a tag
    echo "✅ - Build can proceed"
    exit 1;
  fi

  echo "🛑 - Main build, not changesets, cancelled"
  exit 0;

else
  # Build everything else
	echo "✅ - Build can proceed"
  exit 1;
fi
