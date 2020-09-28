package version

import (
	"fmt"
	"os"

	"github.com/jedib0t/go-pretty/table"
)

// Default build-time variable.
// These variables are populated via the Go ldflags.
// This will be filled in by the compiler.
var (
	UTCBuildTime  string = "unknown-utc-build-time"
	ClientVersion string = "unknown-cli-version"
	GoVersion     string = "unknown-go-version"
	GitBranch     string = "unknown-git-branch"
	GitTag        string = "unknown-git-tag"
	GitHash       string = "unknown-git-hash"
)

// GetDisplay function - parse current version and return a formatted string.
func GetDisplay() string {
	return fmt.Sprintf("CLI Version - %s", ClientVersion)
}

// GetPrettyDetails function - create a pretty table and parse this table with current version details.
func GetPrettyDetails() {
	t := table.NewWriter()
	t.SetOutputMirror(os.Stdout)
	t.AppendHeader(table.Row{"Info", "Content"})
	t.AppendRows([]table.Row{
		{"UTC Build Time", UTCBuildTime},
		{"Go Version", GoVersion},
		{"Git Branch", GitBranch},
		{"Git Hash", GitHash},
	})
	t.SetStyle(table.StyleColoredBright)
	t.Render()
}

// ShowVersion function - check detail flag and show the pretty details if enabled (`true`).
func ShowVersion(detail bool) {
	if detail {
		fmt.Printf("%s\n\n", GetDisplay())
		GetPrettyDetails()
	} else {
		fmt.Printf("%s\n", GetDisplay())
	}
}
