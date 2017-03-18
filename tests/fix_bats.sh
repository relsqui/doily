# This fixes a known bug in Bats (https://github.com/sstephenson/bats/issues/140#issuecomment-206756745)

if [[ -z "${BATS_PREFIX}" ]]; then
    BATS_PREFIX=/usr/local
fi

if [[ -e /usr/local/libexec/bats-exec-suite ]]; then
    bats_exec_suite="${BATS_PREFIX}/libexec/bats-exec-suite"
elif [[ -e /usr/lib/bats/bats-exec-suite ]]; then
    bats_exec_suite="/usr/lib/bats/bats-exec-suite"
else
    echo "Couldn't find bats-exec-suite. If you installed it manually"\
         "somewhere other than /usr/local, set BATS_PREFIX to the install"\
         "prefix, export it, and try again."
    exit 1
fi

line20="$(cat "${bats_exec_suite}" | head -n 20 | tail -n 1)"
buggy_line='  let count+="$(bats-exec-test -c "$filename")"'

if [[ "${line20}" != "${buggy_line}" ]]; then
    echo "The line that needs fixing has changed or moved! If tests still"\
         "aren't running, it's for a reason other than the one this script"\
         "knows how to fix."
    exit 2
fi

read -rd '' replacement <<'EOF'
  _count=$(bats-exec-test -c "$filename")
  : "$(( count+=_count ))"
  # ^-- This is an automatic bug fix. Original line:
  # let count+="$(bats-exec-test -c "$filename")"
EOF

replacement="$(echo "${replacement}" | tr '\n' '%' | sed 's/%$//' | sed 's/%/\\n/g')"
sudo sed -i "20s/.*/  ${replacement}/" "${bats_exec_suite}"
