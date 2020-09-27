package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

type completionCommand struct {
	cmd *cobra.Command
}

func newCompletionCommand() *completionCommand {
	cmd := &cobra.Command{
		Use:   "completion [bash|zsh|fish|powershell]",
		Short: "Load shell completions",
		Long: `To load completions:

	Bash:
	$ source <(gen completion bash)

	# To load completions for each session, execute once:
	Linux:
		$ gen completion bash > /etc/bash_completion.d/gen
	MacOS:
		$ gen completion bash > /usr/local/etc/bash_completion.d/gen

	Zsh:
	$ source <(gen completion zsh)

	# To load completions for each session, execute once:
	$ gen completion zsh > "${fpath[1]}/_gen"

	Fish:
	$ gen completion fish | source

	# To load completions for each session, execute once:
	$ gen completion fish > ~/.config/fish/completions/gen.fish
	`,
		Hidden:                false,
		DisableFlagsInUseLine: true,
		ValidArgs:             []string{"bash", "zsh", "fish", "powershell"},
		Args:                  cobra.ExactValidArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			var err error
			switch args[0] {
			case "bash":
				err = cmd.Root().GenBashCompletion(os.Stdout)
			case "zsh":
				err = cmd.Root().GenZshCompletion(os.Stdout)
			case "fish":
				err = cmd.Root().GenFishCompletion(os.Stdout, true)
			case "powershell":
				err = cmd.Root().GenPowerShellCompletion(os.Stdout)
			}
			return err
		},
	}
	return &completionCommand{cmd: cmd}
}
