/*
Package cmd includes call for Gen CLI.

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
	"strings"

	"github.com/common-nighthawk/go-figure"
	"github.com/lpmatos/gen/internal/constants"
	"github.com/lpmatos/gen/internal/utils"
	"github.com/mitchellh/go-homedir"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var (
	logLevel string // Local flag - global log level.
	cfgFile  string // Local flag - global config file.
)

// RootCmd represents the base command when called without any subcommands.
var RootCmd = &cobra.Command{
	Use:   "gen",
	Short: "A powerful CLI that helps your project startup",
	Long:  constants.RootHelpMessage,
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		// set logLevel if posible
		logrusLevel := viper.GetString("logLevel")
		utils.SetLogLevel(logrusLevel)
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	title := func() {
		figure.NewColorFigure("Gen", "", "yellow", false).Print()
		endline := func() {
			fmt.Println("")
		}
		endline()
	}
	title()
	if err := RootCmd.Execute(); err != nil {
		log.Fatalf("Error while executing RootCmd: %s", err)
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	RootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "Config file (default is $HOME/.gen.yaml)")
	RootCmd.PersistentFlags().StringVar(&logLevel, "logLevel", "", "Set the logging level. One of: debug|info|warn|error")

	viper.BindPFlag("logLevel", RootCmd.PersistentFlags().Lookup("logLevel"))

	viper.SetDefault("logLevel", "info")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	// set loglevel if possible
	logLevel := viper.GetString("loglevel")
	utils.SetLogLevel(logLevel)

	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := homedir.Dir()
		if err != nil {
			log.Fatalf("Error while finding home directory: %s", err)
		}
		// Search config in home directory with name ".gen" (without extension).
		viper.AddConfigPath(home)
		viper.SetConfigName(".gen")
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err != nil {
		// NOTE: the config file is not required to exists
		// raise an error if error is other than config file not found
		if !strings.Contains(err.Error(), `config file ".gen.yaml" not found`) {
			log.Error(err)
		}
	}
}
