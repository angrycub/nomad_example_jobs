#!/bin/sh

echo "📦 Creating site tarball..."
cd site-content &&
tar -zcvf ../site-content.tgz * &&
cd ..
