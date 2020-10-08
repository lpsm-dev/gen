VERSION=`cat VERSION`

TAGS=`git tag`

if [[ "$TAGS" =~ "$VERSION" ]]; then
  echo "Remove tag"
  git tag -d $VERSION
fi


if [[ "$VERSION" =~ "v" ]]; then
  echo "Create git tag"
  git tag $VERSION
  echo "Push git tag"
  git push --tags
else
  echo "Invalid Version!"
fi
