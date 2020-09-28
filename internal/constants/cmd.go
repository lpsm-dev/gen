package constants

// RootHelpMessage - return the long description of root command.
const RootHelpMessage = `Description:

A CLI tool that automate your project startup:

- Template project with pretty README.md, LICENSE, gitignore
- Good Commit Messages Pattern with Conventional Commits
`

// CompletionHelpMessage - return the long description of completion command.
const CompletionHelpMessage = `To load completions:

Bash:
$ source <(gen completion bash)

Zsh:
$ source <(gen completion zsh)

# To load completions for each session, execute once:
$ gen completion zsh > "${fpath[1]}/_gen"

Fish:
$ gen completion fish | source

# To load completions for each session, execute once:
$ gen completion fish > ~/.config/fish/completions/gen.fish

# To load completions for each session, execute once:
Linux:
	$ gen completion bash > /etc/bash_completion.d/gen
MacOS:
	$ gen completion bash > /usr/local/etc/bash_completion.d/gen
`
