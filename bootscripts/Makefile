ETCDIR=/etc
EXTDIR=${DESTDIR}${ETCDIR}
MODE=754
DIRMODE=755
CONFMODE=644

all: install

create-dirs:
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/start
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/stop
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/init.d

install: create-dirs
	install -m ${CONFMODE} clfs/rc.d/init.d/functions ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} clfs/rc.d/startup         ${EXTDIR}/rc.d/
	install -m ${MODE} clfs/rc.d/shutdown        ${EXTDIR}/rc.d/
	install -m ${MODE} clfs/rc.d/init.d/network  ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} clfs/rc.d/init.d/syslog   ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} clfs/rc.d/init.d/bridge   ${EXTDIR}/rc.d/init.d/
	ln -sf ../init.d/syslog ${EXTDIR}/rc.d/start/S05syslog
	ln -sf ../init.d/syslog ${EXTDIR}/rc.d/stop/K99syslog
	ln -sf ../init.d/network ${EXTDIR}/rc.d/start/S10network
	ln -sf ../init.d/network ${EXTDIR}/rc.d/stop/K80network
	ln -sf ../init.d/bridge ${EXTDIR}/rc.d/start/S09bridge
	ln -sf ../init.d/bridge ${EXTDIR}/rc.d/stop/K81bridge

install-dropbear: create-dirs
	install -m ${MODE} clfs/rc.d/init.d/sshd   ${EXTDIR}/rc.d/init.d/
	ln -sf ../init.d/sshd ${EXTDIR}/rc.d/start/S30sshd
	ln -sf ../init.d/sshd ${EXTDIR}/rc.d/stop/K30sshd

install-bcm47xx: create-dirs
	install -m ${MODE} clfs/rc.d/init.d/bcm47xx-switch ${EXTDIR}/rc.d/init.d/
	ln -sf ../init.d/bcm47xx-switch ${EXTDIR}/rc.d/start/S08bcm47xx-switch
	ln -sf ../init.d/bcm47xx-switch ${EXTDIR}/rc.d/stop/K82bcm47xx-switch

.PHONY: all create-dirs install install-dropbear install-bridge
