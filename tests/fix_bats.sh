# This fixes a known bug in Bats (https://github.com/sstephenson/bats/issues/140#issuecomment-206756745)
sudo sed -i "20s/.*/  _count=\$(bats-exec-test -c \"\$filename\"); : \"\$(( count+=_count ))\"/" /usr/lib/bats/bats-exec-suite
