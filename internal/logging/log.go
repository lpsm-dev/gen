package logging

import "github.com/sirupsen/logrus"

// logger variable - Local variable logrus logger.
var logger *logrus.Logger

// Setup function - configure logrus logger.
func Setup() {
	logger = logrus.New()
	logger.SetReportCaller(false)
	Formatter := &logrus.TextFormatter{
		TimestampFormat: "2006-01-02 15:04:05",
		FullTimestamp:   true,
		DisableColors:   false,
	}
	logger.SetFormatter(Formatter)
}
