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

	"github.com/lpmatos/gen/internal/constants"
	"github.com/mitchellh/go-homedir"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var (
	logLevel string
	cfgFile  string
)

// RootCmd represents the base command when called without any subcommands.
var RootCmd = &cobra.Command{
	Use:   "gen",
	Short: "A powerful CLI that helps your project startup",
	Long:  constants.RootHelpMessage,
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		// set logLevel if posible
		logrusLevel, err := log.ParseLevel(viper.GetString("logLevel"))
		if err == nil {
			log.SetLevel(logrusLevel)
		}
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
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
	viper.AutomaticEnv()

	// set loglevel if possible
	logLevel, err := log.ParseLevel(viper.GetString("loglevel"))

	if err == nil {
		log.SetLevel(logLevel)
	}

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

	if err := viper.ReadInConfig(); err == nil {
		log.Info("Using config file:", viper.ConfigFileUsed())
		fmt.Println()
	} else {
		log.Info("No config file found")
		fmt.Println()
	}
}
