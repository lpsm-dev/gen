package util

// These variables are populated via the Go linker.
// This will be filled in by the compiler.
var (
	UTCBuildTime  string
	ClientVersion string
	GoVersion     string
	GitBranch     string
	GitTag        string
	GitHash       string
)
