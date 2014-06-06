# vim-inner-paren-hl


Highlights surrounding parentheses as the cursor moves.

Inspired by [vim-matchopen](https://github.com/haruyama/vim-matchopen).

## Installation

Using [NeoBundle](https://github.com/Shougo/neobundle.vim):

```
NeoBundle 'neapel/vim-inner-paren-hl'
```

Or, using [Vundle](https://github.com/gmarik/Vundle.vim):
```
Plugin 'neapel/vim-inner-paren-hl'
```

Or, using [Pathogen](https://github.com/tpope/vim-pathogen):
```
cd ~/.vim/bundle
git clone https://github.com/neapel/vim-inner-paren-hl.git
```

## Configuration

Configure the highlight group the plugin will use
(it sets this default on loading, which works nicely with a light off-white normal background)
```
highlight innerparenhlSpan guibg=#ffffff
```

The plugin uses your matchpairs setting, by default configured as:
```
set matchpairs=(:),{:},[:]
```

Use the `:NoInnerParenHighlight` or `:DoInnerParenHighlight` commands to temporarily disable and enable the autocommand.
