PACKAGE=pkgdaemon
VERSION=1.0.3
MAINTAINER=Andrei Avram <avramandrei@ymail.com>
SHORT_DESCRIPTION=The short description
DESCRIPTION=The long description text of the package
BUILD=`git rev-parse HEAD`
LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD}"
RELEASE=release/${PACKAGE}

init:
	@cp -r template/package ${RELEASE}

	@mv ${RELEASE}/etc/init.d/script ${RELEASE}/etc/init.d/${PACKAGE}
	@chmod 0755 ${RELEASE}/etc/init.d/${PACKAGE}
	@sed -i -E "s#(<PACKAGE>)#${PACKAGE}#" ${RELEASE}/etc/init.d/${PACKAGE}
	@sed -i -E "s#(<SHORT_DESCRIPTION>)#${SHORT_DESCRIPTION}#" ${RELEASE}/etc/init.d/${PACKAGE}
	@sed -i -E "s#(<DESCRIPTION>)#${DESCRIPTION}#" ${RELEASE}/etc/init.d/${PACKAGE}
	@sed -i -E "s#(<DAEMON>)#/usr/local/bin/${PACKAGE}#" ${RELEASE}/etc/init.d/${PACKAGE}

	@mv ${RELEASE}/etc/package ${RELEASE}/etc/${PACKAGE}
	@cp -r config/* ${RELEASE}/etc/${PACKAGE}
	
	@mv ${RELEASE}/log/package.log ${RELEASE}/log/${PACKAGE}.log
	@mv ${RELEASE}/run/package.pid ${RELEASE}/log/${PACKAGE}.pid
	
	@chmod 0755 ${RELEASE}/DEBIAN/postinst
	@sed -i -E "s#(<PACKAGE>)#${PACKAGE}#" ${RELEASE}/DEBIAN/postinst

	@sed -i -E "s#(<PACKAGE>)#${PACKAGE}#" ${RELEASE}/DEBIAN/control
	@sed -i -E "s#(<VERSION>)#${VERSION}#" ${RELEASE}/DEBIAN/control
	@sed -i -E "s#(<MAINTAINER>)#${MAINTAINER}#" ${RELEASE}/DEBIAN/control
	@sed -i -E "s#(<SHORT_DESCRIPTION>)#${SHORT_DESCRIPTION}#" ${RELEASE}/DEBIAN/control
	@sed -i -E "s#(<DESCRIPTION>)#${DESCRIPTION}#" ${RELEASE}/DEBIAN/control

	@find ${RELEASE} -name ".gitkeep" -delete

build:
	go get
	go test
	go build ${LDFLAGS} -o ${RELEASE}/usr/local/bin/${PACKAGE}
	@chmod +x ${RELEASE}/usr/local/bin/${PACKAGE}
	
	@CHECKSUM_HASH=`shasum -a 1 ${RELEASE}/usr/local/bin/${PACKAGE} | cut -d ' ' -f 1`; \
		sed -i -E "s#(<CHECKSUM_HASH>)#$$CHECKSUM_HASH#" ${RELEASE}/DEBIAN/control
	@sed -i -E "s#(<CHECKSUM_ALGORITHM>)#SHA1#" ${RELEASE}/DEBIAN/control
	
package:
	dpkg-deb --build release/${PACKAGE}

clean:
	@rm -rf release/${PACKAGE}
