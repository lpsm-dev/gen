package helpers

import (
	"os"
	"time"
)

// DoesPathExist checks if a given path exists in the filesystem.
func DoesPathExist(path string) bool {
	_, err := os.Stat(path)
	return !os.IsNotExist(err)
}

// CreateFolderIfNotExists creates a folder at the given path if it doesn't already exist.
func CreateFolderIfNotExists(path string) error {
	_, err := os.Stat(path)
	if !os.IsNotExist(err) {
		return err
	}
	return os.MkdirAll(path, os.ModePerm)
}

// GetCurrentDate function - return the current date in the system.
func GetCurrentDate() string {
	currentTime := time.Now()
	return currentTime.Format("Mon 2006-01-2")
}
