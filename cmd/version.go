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

	"github.com/lpmatos/gen/util"
	"github.com/spf13/cobra"
)

// versionCmd is a struct to represent a cobra cli command.
type versionCmd struct{ cmd *cobra.Command }

// createVersionCmd represents the `version` command.
func createVersionCmd() *versionCmd {
	cmd := &cobra.Command{
		Use:     "version",
		Aliases: []string{"v"},
		Short:   "Print the version number of Gen CLI",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println(util.ClientVersion)
			if detail {
				fmt.Println("Version details")
			}
		},
	}
	cmd.PersistentFlags().BoolVarP(&detail, "detail", "d", false, "detail current version")
	return &versionCmd{cmd: cmd}
}
