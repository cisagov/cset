#!/bin/bash
shopt extglob dotglob nullglob

DEPLOY_DIR='//cset-tst.inl.gov/csetdemo'

copyJs() {
	echo 'copying .js'
	cp dist/*.js $DEPLOY_DIR
}

copyOther() {
	echo 'copying other'
	cp dist/*.html $DEPLOY_DIR
	cp dist/*.ico $DEPLOY_DIR
	cp dist/*.css $DEPLOY_DIR
}

copyEot() {
	echo 'copying .eot'
	cp dist/*.eot $DEPLOY_DIR
}

copySvg() {
	echo 'copying .svg'
	cp dist/*.svg $DEPLOY_DIR
}

copyTtf() {
	echo 'copying .ttf'
	cp dist/*.ttf $DEPLOY_DIR
}

copyWoff() {
	echo 'copying .woff'
	cp dist/*.woff $DEPLOY_DIR
	cp dist/*.woff2 $DEPLOY_DIR
}

copyBin() {
	echo 'copying bin'
	cp dist/bin/*.dll $DEPLOY_DIR/bin
}

copyLucene() {
	echo 'copying Lucene'
	cp dist/Lucene/*.* $DEPLOY_DIR/Lucene
}

copyJs &
copyOther &
copyEot &
copySvg &
copyTtf &
copyWoff &
copyBin &

#if (1) {
#	copyLucene &
#}

wait

echo 'Copy complete'



