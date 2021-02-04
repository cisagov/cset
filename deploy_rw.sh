#!/bin/bash
shopt extglob dotglob nullglob

DEPLOY_DIR='//csetac.inl.gov/csetac'

copyJS() {
	echo 'copying .js'
	cp dist/*.js $DEPLOY_DIR
	echo 'finished .js'
}

copyOther() {
	echo 'copying other'
	cp dist/*.html $DEPLOY_DIR
	echo 'finished .html (other)'
	cp dist/*.ico $DEPLOY_DIR
	echo 'finished .ico (other)'
	cp dist/*.css $DEPLOY_DIR
	echo 'finished .css (other)'
	cp dist/web.config $DEPLOY_DIR
	echo 'finished other'
}

copyEOT() {
	echo 'copying .eot'
	cp dist/*.eot $DEPLOY_DIR
	echo 'finished .eot'
}

copySVG() {
	echo 'copying .svg'
	cp dist/*.svg $DEPLOY_DIR
	echo 'finished .svg'
}

copyTTF() {
	echo 'copying .ttf'
	cp dist/*.ttf $DEPLOY_DIR
	echo 'finished .ttf'
}

copyWOFF() {
	echo 'copying .woff'
	cp dist/*.woff $DEPLOY_DIR
	cp dist/*.woff2 $DEPLOY_DIR
	echo 'finished .woff'
}

copyBin() {
	echo 'copying bin'
	cp dist/bin/*.dll $DEPLOY_DIR/bin
	echo 'finished bin'
}

copyLucene() {
	echo 'copying Lucene'
	cp dist/Lucene/*.* $DEPLOY_DIR/Lucene
	echo 'finished Lucene'
}

date

copyJS &
copyOther &
copyEOT &
copySVG &
copyTTF &
copyWOFF &
copyBin &

#if (1) {
#	copyLucene &
#}

wait

date

echo 'Copy complete'



