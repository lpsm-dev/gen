VERSION=`cat VERSION`

if [[ "$VERSION" =~ "v" ]]; then
  echo "Create git tag"
  git tag $VERSION
  echo "Push git tag"
  git push --tags
else
  echo "Invalid Version!"
fi
