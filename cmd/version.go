/*
Package main includes call for Gen CLI.

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
	"github.com/lpmatos/gen/internal/version"
	"github.com/spf13/cobra"
)

// detauk flag for show more info about the current version.
var detail = false

// Local function that represents the `version` command.
func createVersionCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:     "version",
		Aliases: []string{"v"},
		Short:   "Show the current version of Gen CLI",
		Run: func(cmd *cobra.Command, args []string) {
			version.ShowVersion(detail)
		},
	}
	cmd.PersistentFlags().BoolVarP(&detail, "detail", "d", false, "show more details of the current version")
	return cmd
}
