FROM golang:1.13-stretch

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV TERM xterm-256color

RUN apt-get update && apt-get install tmux git curl rsync inotify-tools ca-certificates -y --no-install-recommends \
    # config nodejs source
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    # configure yarn source
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    # install nodejs & yarn
    && apt-get update && apt-get install nodejs yarn -y --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 gopher && \
    useradd -s /bin/bash -r -u 1000 -g gopher gopher && \
    cp /bin/bash /bin/sh

ENV HOME=/home/gopher
# neovim
COPY nvim/* $HOME/.config/nvim/
ADD https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz /tmp/
RUN cd /tmp && tar -xf nvim-linux64.tar.gz && \
    cp -a nvim-linux64/* /usr/local/ && \
    rm -rf /tmp/* && \
    # install Plug
    curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    nvim +PlugInstall +qall && \
    nvim -c 'CocInstall -sync coc-go coc-json coc-html coc-emmet coc-tsserver|q' && \
    # neovim alias
    ln -s /usr/local/bin/nvim /usr/local/bin/vim && \
    ln -s /usr/local/bin/nvim /usr/local/bin/vi

# git prompt
COPY bin/studio /usr/local/bin/studio
COPY .bashrc $HOME/.bashrc
RUN curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o $HOME/.git-prompt.sh && \
    chmod +x $HOME/.git-prompt.sh && \
    chmod +x /usr/local/bin/studio

# tmux
COPY tmux/.tmux.conf $HOME/.tmux.conf

WORKDIR /workspace/src

# switch user
RUN chown -R gopher $HOME /go /workspace && \
    echo "source ~/.bashrc" >> $HOME/.bash_profile
USER gopher

CMD ["studio"]