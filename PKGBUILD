# Maintainer: Your Name <mmirate@gmx.com>
pkgname=siren-git
_gitname=siren
pkgver=0.0.0
pkgrel=1
pkgdesc="Minimalistic mail forwarder."
arch=('any')
url="https://github.com/mmirate/siren"
license=('GPL')
depends=('perl' 'perl-io-all' 'perl-ipc-run')
makedepends=('git')
conflicts=()
provides=()
#source=('git://github.com/mmirate/siren.git')
source=('git+https://github.com/mmirate/siren.git'
md5sums=('SKIP')

pkgver() {
  cd $_gitname
  echo $(git rev-list --count master).$(git rev-parse --short master)
}

package() {
  cd $_gitname
  install -Dm755 ${_gitname}.pl "$pkgdir/usr/sbin"
}
