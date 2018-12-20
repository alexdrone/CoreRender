#!/bin/bash
format() {
  PATH=$(pwd);
  echo "✓ $PATH";
  clang-format -i *.h &>/dev/null
  clang-format -i *.m &>/dev/null
  clang-format -i *.mm &>/dev/null
  clang-format -i *.c &>/dev/null
}

echo "Running clang-format..."
cd src && format;
cd yoga && format;
cd ../../test && format;
cd ../macOS && format;
