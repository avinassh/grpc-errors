mkdir dest
mv README.md source/
rm -rf assets _site index.html
jekyll build --source source --destination dest
mv source/README.md .
rm dest/README.md
mv -f dest/* .
rm -rf dest _site
python3 -m http.server 5879
