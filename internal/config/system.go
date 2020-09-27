package config

import "os"

// GetEnv function - return the value of and env variable if exist and if not return a fallback.
func GetEnv(env, fallback string) string {
	if value, okay := os.LookupEnv(env); okay {
		return value
	}
	return fallback
}
