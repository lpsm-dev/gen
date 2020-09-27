/*
Copyright © 2020 NAME HERE luccpsm@gmail.com

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

	"github.com/common-nighthawk/go-figure"
	"github.com/lpmatos/gen/internal/constants"
	"github.com/spf13/cobra"
)

type rootCmd struct {
	cmd *cobra.Command
}

// rootCmd represents the base command when called without any subcommands.
func newRootCmd() *rootCmd {
	cmd := &cobra.Command{
		Use:   "gen [sub]",
		Short: "A powerful CLI that helps your project startup",
		Long:  constants.RootHelpMessage,
	}
	cmd.AddCommand(
		newCompletionCommand().cmd,
	)
	return &rootCmd{cmd: cmd}
}

func init() {
	title := func() {
		figure.NewColorFigure("Gen", "", "yellow", false).Print()
		endline := func() {
			fmt.Println("")
		}
		endline()
	}
	title()
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := newRootCmd().cmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
