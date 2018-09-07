files=`git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT`

sed 's/<members>*<\/members>/<members>$files<\/members>/g' package.xml