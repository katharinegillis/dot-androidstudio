#!/usr/bin/env bash

pkg.link() {
    [ -d "$PKG_PATH/files" ] && fs.link_files $PKG_PATH/files
    [ -d "$PKG_PATH/bin" ] && fs.link_rfiles $PKG_PATH/bin $HOME/bin
}

pkg.install() {
    [ -f "$PKG_PATH/install.sh" ] && bash $PKG_PATH/install.sh "$ELLIPSIS_SRC" "$PKG_PATH"

    [ -f ".restart.lock" ] &&
      echo "" &&
      echo -e "\e[33mPlease restart the computer and then re-run the ellipsis command from a WSL prompt to continue the installation.\e[0m" &&
      rm -rf .restart.lock &&
      exit 1
}

pkg.pull() {
    # Check for updates on git
    git remote update 2>&1 > /dev/null
    if git.is_behind; then
        # Unlink old files
        hooks.unlink

        # Pull package changes
        git.pull

        # Link new files
        pkg.link
    fi

    [ -f "$PKG_PATH/update.sh" ] && bash $PKG_PATH/update.sh "$ELLIPSIS_SRC" "$PKG_PATH"

    [ -f ".restart.lock" ] &&
      echo "" &&
      echo -e "\e[33mPlease restart the computer and then re-run the ellipsis command from a WSL prompt to continue the update.\e[0m" &&
      rm -rf .restart.lock &&
      exit 1
}

pkg.uninstall() {
    [ -f "$PKG_PATH/uninstall.sh" ] && bash $PKG_PATH/uninstall.sh "$ELLIPSIS_SRC" "$PKG_PATH"

    [ -f ".restart.lock" ] &&
      echo "" &&
      echo -e "\e[33mPlease restart the computer and then re-run the ellipsis command from a WSL prompt to continue the uninstall.\e[0m" &&
      rm -rf .restart.lock &&
      exit 1
}
