/*
Package cmd includes all of the gen CLI commands.

Copyright © 2020 Lucca Pessoa <luccpsm@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"fmt"
	"os"

	"github.com/lpmatos/gen/internal/constants"
	"github.com/spf13/cobra"
)

// completionCmd is a struct to represent the completition command in cobra.
type completionCmd struct {
	cmd *cobra.Command
}

// newCompletionCmd represents the `completion` command.
func newCompletionCmd() *completionCmd {
	cmd := &cobra.Command{
		Use:                   "completion <shell>",
		Short:                 "Load shell completions",
		Long:                  constants.CompletionHelpMessage,
		Hidden:                false,
		DisableFlagsInUseLine: true,
		ValidArgs:             []string{"bash", "zsh", "fish", "powershell"},
		Args: func(cmd *cobra.Command, args []string) error {
			if cobra.ExactArgs(1)(cmd, args) != nil || cobra.OnlyValidArgs(cmd, args) != nil {
				return fmt.Errorf("only %v arguments are allowed", cmd.ValidArgs)
			}
			return nil
		},
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
	return &completionCmd{cmd: cmd}
}
