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
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var (
	useConfigFile bool                   // indicate using config (from $PWD/.cgapp.yml)
	projectConfig map[string]interface{} // parse project config
)

type rootCmd struct {
	cmd *cobra.Command
}

// rootCmd represents the base command when called without any subcommands.
func newRootCmd() *rootCmd {
	cmd := &cobra.Command{
		Use:   "gen [sub]",
		Short: "A powerful CLI that helps your project startup",
		Long: `Description:

This CLI tool helps to start a Git project using some good standards.

A CLI tool that automate your project startup (pretty README.md, LICENSE, gitignore...)
	`,
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
	cobra.OnInitialize(initConfig)
}

// initConfig reads in config file, if set.
func initConfig() {
	if useConfigFile {
		// Get current directory.
		currentDir, _ := os.Getwd()

		viper.AddConfigPath(currentDir) // add config path
		viper.SetConfigName(".gen")     // set config name

		// If a config file is found, read it in.
		if err := viper.ReadInConfig(); err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		// Parse configs.
		_ = viper.UnmarshalKey("project", &projectConfig)
	}
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := newRootCmd().cmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
