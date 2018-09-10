echo '<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <version>43.0</version>
</Package>' > src/package.xml

for files in `git diff-tree --no-commit-id --name-only -r TRAVIS_COMMIT`
do
	if [[ $files = *"src/classes/"* ]]; then
		class=true
		classes+=( ${files#*src/classes/} )
	fi

	if [[ $files = *"src/package"* ]]; then
		page=true
		pages+=( ${files#*src/} )
	fi
done

if [[ '$class'=true ]]; then
	sed -i '/<version>/i \\t<types>\n\t\t<name>ApexClass</name>\n\t</types>' src/package.xml
	for (( i=0; i<${#classes[@]}; i++))
	do
		sed -i '/ApexClass/i \\t\t<members>'${classes[$i]}'</members>' src/package.xml
	done
fi

if [[ '$page'=true ]]; then
	sed -i '/<version>/i \\t<types>\n\t\t<name>ApexPage</name>\n\t</types>' src/package.xml
	for (( i=0; i<${#pages[@]}; i++))
	do
		sed -i '/ApexPage/i \\t\t<members>'${pages[$i]}'</members>' src/package.xml
	done
fi

cat src/package.xml