echo '<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <version>43.0</version>
</Package>' > src/package.xml

for files in `git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT`
do
	if [[ $files = *"src/classes/"* ]]; then
		class=true
		classes+=( ${files#*src/classes/} )
	fi

	if [[ $files = *"src/triggers/"* ]]; then
		trigger=true
		triggers+=( ${files#*src/triggers/} )
	fi
done

if [[ '$class'=true ]]; then
	sed -i '/<version>/i \\t<types>\n\t\t<name>ApexClass</name>\n\t</types>' src/package.xml
	for (( i=0; i<${#classes[@]}; i++))
	do
		sed -i '/ApexClass/i \\t\t<members>'${classes[$i]}'</members>' src/package.xml
	done
fi

if [[ '$trigger'=true ]]; then
	sed -i '/<version>/i \\t<types>\n\t\t<name>ApexTriggers</name>\n\t</types>' src/package.xml
	for (( i=0; i<${#triggers[@]}; i++))
	do
		sed -i '/ApexTriggers/i \\t\t<members>'${triggers[$i]}'</members>' src/package.xml
	done
fi

cat src/package.xml