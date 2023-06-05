ARG VARIANT=2-linux
FROM mcr.microsoft.com/vscode/devcontainers/universal:${VARIANT}

# ** [Optional] Uncomment this section to install additional packages. **
USER root

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends tig neovim tmux ctags

# install k3d 
RUN curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

# tools
COPY --from=seanly/opsbox:toolset \
        /usr/bin/yq \
        /usr/bin/docker-compose \
        /usr/bin/helm \
        /usr/bin/kustomize \
        /usr/bin/kubectl \
        /usr/bin/fzf \
    /usr/bin/

# Enable new "BUILDKIT" mode for Docker CLI
ENV DOCKER_BUILDKIT=1

USER codespace

COPY --from=seanly/toolset:krew /root/.krew ~/.krew
ENV PATH="${PATH}:~/.krew/bin"

RUN set -eux \
  ; mkdir -p ~/.oh-my-zsh/custom/plugins \
  ; git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
  ; git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
  ; git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search.git ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search \
  ; git clone --depth 1 https://github.com/Dbz/kube-aliases.git ~/.oh-my-zsh/custom/plugins/kube-aliases

# vimrc
COPY --from=seanly/toolset:vimrc /package/vim/init.vim ~/.vimrc
RUN curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    ;mkdir -p ~/.config/nvim; ln -s ~/.vimrc ~/.config/nvim/init.vim\
    ;sed -i 's;=(git);=(git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting kube-aliases kube-ps1);g' ~/.zshrc \
    ;echo "alias vim=nvim" >> ~/.zshrc \
    ;echo "alias k=kubectl" >> ~/.zshrc \
    ;echo "alias vi=nvim" >> ~/.zshrc \
    ;echo "PROMPT='\$(kube_ps1)'\$PROMPT" >> ~/.zshrc \
    # fix kubectx error: /root/.krew/bin/kubectl-ctx: line 106: /root/.kube/kubectx: No such file or directory
    ;mkdir -p ~/.kube 

ENV SHELL=/bin/zsh